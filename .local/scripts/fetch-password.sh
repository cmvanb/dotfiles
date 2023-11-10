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

    # Exit with the parameterized error code.
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
    echo "Missing parameter: target" 1>&2
    newline

    exit 1
fi

declare target=$1

# Retrieve secrets
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_SECRETS_HOME/bitwarden"

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

if ! BW_CLIENTID="$BW_CLIENTID" BW_CLIENTSECRET="$BW_CLIENTSECRET" bw login --apikey --raw; then
    echo "Error logging in." 1>&2
    newline

    bw_abort 4
fi

# TODO: Improve handling of `already logged in`.
# echo $LOGIN_result =~ "You are already logged in"
#
# if [[ $? -ne 0 ]]; then
#     if [[ LOGIN_result =~ "You are already logged in" ]]; then
#         echo 'Already logged in, continuing.'
#     else
#         echo $LOGIN_result
#         bw_abort 4
#     fi
# fi

# Require master password
#-------------------------------------------------------------------------------

declare session_key
if ! session_key=$(bw unlock); then
    echo "Error unlocking vault." 1>&2
    newline

    bw_abort 5
fi

# Retrieve target password with session key
#-------------------------------------------------------------------------------

declare result
if ! result=$(bw list items --search "$target" --session "$session_key"); then
    echo "Error listing items." 1>&2
    newline

    bw_abort 6
fi

declare items_count
items_count=$(echo "$result" | jq ". | length")

newline

declare name
declare password

if [[ $items_count -lt 1 ]]; then
    echo "Did not find any items matching input: \`$target\`." 1>&2
    newline

    bw_abort 8

elif [[ $items_count -eq 1 ]]; then
    name=$(printf "%s" "$result" | jq -r ".[] | .name")
    password=$(printf "%s" "$result" | jq -r ".[] | .login.password")

    echo "Found item: \`$name\`"
    newline

elif [[ $items_count -gt 1 ]]; then
    echo "Found multiple items matching input: \`$target\`." 1>&2
    newline

    if ! name="$(printf "%s" "$result" | jq -r ".[].name" | fzf --reverse)"; then
        echo "Error matching input: \`$target\`." 1>&2
        newline

        bw_abort 7
    fi

    password="$(printf "%s" "$result" | jq -r ".[] | select(.name == \"$name\") | .login.password")"

    echo "Selected item: \`$name\`"
fi

# TODO: Implement a solution for the linux virtual terminal scenario.
# Copy result to clipboard so we can use it immediately
wl-copy "$password"

echo "Password is in Wayland clipboard."
newline

# Always lock and logout
#-------------------------------------------------------------------------------

bw_finalize
