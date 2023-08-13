#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Fetch password from Bitwarden
#-------------------------------------------------------------------------------

set -o nounset
set -o pipefail

# Functions
#-------------------------------------------------------------------------------
bw_abort ()
{
    # Always lock and logout.
    bw_finalize
    exit $1
}

bw_finalize ()
{
    bw lock
    bw logout
}

newline ()
{
    printf "\n"
}

# Input validation
#-------------------------------------------------------------------------------
if [[ -z $1 ]]; then
    echo "Missing parameter: TARGET" 1>&2
    newline

    exit 1
fi

TARGET=$1

# Retrieve secrets
#-------------------------------------------------------------------------------
. ~/.secrets/bitwarden

if [[ -z $BW_CLIENTID ]]; then
    echo "Missing secret: BW_CLIENTID" 1>&2
    newline

    exit 2
fi

if [[ -z $BW_CLIENTSECRET ]]; then
    echo "Missing secret: BW_CLIENTSECRET" 1>&2
    newline

    exit 3
fi

# Login to bitwarden CLI with personal API key
#-------------------------------------------------------------------------------
echo "Login to Bitwarden"

LOGIN_RESULT=$(BW_CLIENTID=$BW_CLIENTID BW_CLIENTSECRET=$BW_CLIENTSECRET bw login --apikey --raw)

if [[ $? -ne 0 ]]; then
    echo "Error logging in." 1>&2
    newline

    bw_abort 4
fi

# TODO: Improve handling of `already logged in`.
# echo $LOGIN_RESULT =~ "You are already logged in"
#
# if [[ $? -ne 0 ]]; then
#     if [[ LOGIN_RESULT =~ "You are already logged in" ]]; then
#         echo 'Already logged in, continuing.'
#     else
#         echo $LOGIN_RESULT
#         bw_abort 4
#     fi
# fi

# Require master password
#-------------------------------------------------------------------------------
SESSION_KEY=$(bw unlock)
if [[ $? -ne 0 ]]; then
    echo "Error unlocking vault." 1>&2
    newline

    bw_abort 5
fi

# Retrieve target password with session key
#-------------------------------------------------------------------------------
# RESULT=$(bw get item $TARGET --session $SESSION_KEY)
RESULT=$(bw list items --search $TARGET --session $SESSION_KEY)
if [[ $? -ne 0 ]]; then
    echo "Error listing items." 1>&2
    newline

    bw_abort 6
fi

ITEMS_COUNT=$(echo $RESULT | jq ". | length")

newline

if [[ $ITEMS_COUNT -lt 1 ]]; then
    echo "Did not find any items matching input: \`$TARGET\`." 1>&2
    newline

    bw_abort 8

elif [[ $ITEMS_COUNT -eq 1 ]]; then
    NAME=$(printf "%s" "$RESULT" | jq -r ".[] | .name")
    PASSWORD=$(printf "%s" "$RESULT" | jq -r ".[] | .login.password")

    echo "Found item: \`$NAME\`"
    newline

elif [[ $ITEMS_COUNT -gt 1 ]]; then
    echo "Found multiple items matching input: \`$TARGET\`." 1>&2
    newline

    NAME="$(printf "%s" "$RESULT" | jq -r ".[].name" | fzf --reverse)"

    if [[ $? -ne 0 ]]; then
        echo "Error matching input: \`$TARGET\`." 1>&2
        newline

        bw_abort 7
    fi

    PASSWORD="$(printf "%s" "$RESULT" | jq -r ".[] | select(.name == \"$NAME\") | .login.password")"

    echo "Selected item: \`$NAME\`"
fi

# Copy result to clipboard so we can use it immediately
wl-copy $PASSWORD

echo "Password is in Wayland clipboard."
newline

# Always lock and logout
#-------------------------------------------------------------------------------
bw_finalize

