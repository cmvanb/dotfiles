#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Add a bookmark
#-------------------------------------------------------------------------------

set -uo pipefail

# Imports
#-------------------------------------------------------------------------------

# shellcheck disable=1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"
# shellcheck disable=1091
source "$XDG_OPT_HOME/shell-utils/name-formatting.sh"

# Validation
#-------------------------------------------------------------------------------

assert_dependency yad
assert_dependency esh

bookmark_template="$XDG_TEMPLATES_DIR/bookmark.md~esh"
bookmark_dir="$HOME/Wiki/bookmarks"

if [[ ! -f $bookmark_template ]]; then
    echo "[$(basename "$0")] ERROR: Missing template: \`$bookmark_template\`"
    exit 1
fi

# Parse arguments
#-------------------------------------------------------------------------------

input_name="${1:-New Bookmark}"
input_url="${2:-https://}"

# Open a form dialog to get user input for bookmark data
#-------------------------------------------------------------------------------

if ! form_input=$(yad --form \
    --width=640 \
    --title="Add bookmark" \
    --field="Name" "$input_name" \
    --field="URL" "$input_url" \
    --field="Tags!Tags should be space separated." ""\
    --button="OK":0 \
    --button="Cancel":1 \
    );
then
    echo "[$(basename "$0")] ERROR: User cancelled script."
    exit 1
fi

# Process and validate the form input
#-------------------------------------------------------------------------------

# Validate name.
new_bookmark_name=$(echo "$form_input" | cut -d "|" -f 1)

if [[ -z "$new_bookmark_name" ]]; then
    echo "[$(basename "$0")] ERROR: Missing or bad input for bookmark name."
    exit 20
fi

new_bookmark_name_kebab=$(convert_to_kebab_case "$new_bookmark_name")

# Validate URL.
new_bookmark_url=$(echo "$form_input" | cut -d "|" -f 2)

if [[ -z "$new_bookmark_url" ]]; then
    echo "[$(basename "$0")] ERROR: Missing or bad input for bookmark url."
    exit 21
fi

# Validate tags.
declare -a input_tags=()
declare -a new_bookmark_tags=()

IFS=' ' read -r -a input_tags <<< "$(echo "$form_input" | cut -d "|" -f 3)"

for t in "${input_tags[@]}"; do
    # TODO: Ignore duplicate tags.
    # Ignore 1-char tags and empty tags.
    if [[ "${#t}" -gt 1 ]] && [[ -n "$t"  ]]; then
        new_bookmark_tags+=("$(convert_to_kebab_case "$t")")
    fi
done

if [[ -z "$new_bookmark_tags" ]]; then
    echo "[$(basename "$0")] ERROR: Missing or bad input for bookmark tags."
    exit 22
fi

# Validate file path.
bookmark_file_path="$bookmark_dir/$new_bookmark_name_kebab.md"

# NOTE: Should we also check the URL being already being bookmarked?
if [[ -f "$bookmark_file_path" ]]; then
    echo "[$(basename "$0")] ERROR: Bookmark already exists: \`$bookmark_file_path\`"
    exit 23
fi

# Create a bookmark
#-------------------------------------------------------------------------------

# echo "$new_bookmark_name"
# echo "$new_bookmark_name_kebab"
# echo "$new_bookmark_url"
# echo "${new_bookmark_tags[*]}"

esh -o "$bookmark_file_path" "$bookmark_template" \
    new_bookmark_name="$new_bookmark_name" \
    new_bookmark_name_kebab="$new_bookmark_name_kebab" \
    new_bookmark_url="$new_bookmark_url" \
    new_bookmark_tags="${new_bookmark_tags[*]}"
