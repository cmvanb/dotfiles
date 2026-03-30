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

# Helpers
#-------------------------------------------------------------------------------

_script=$(basename "$0")

err() {
    local msg="$*"
    echo "[$_script] ERROR: $msg" >&2
    notify-send "$_script" "$msg"
}

# Validation
#-------------------------------------------------------------------------------

assert_dependency yad

bookmark_template="$XDG_TEMPLATES_DIR/bookmark.mako.md"
bookmark_dir="$HOME/Wiki/bookmarks"

if [[ ! -f $bookmark_template ]]; then
    err "Missing template: \`$bookmark_template\`"
    exit 1
fi

# Parse arguments
#-------------------------------------------------------------------------------

input_name="${1:-New Bookmark}"
input_url="${2:-}"

# Open a form dialog to get user input for bookmark data
#-------------------------------------------------------------------------------

if ! form_input=$(yad --form \
    --width=640 \
    --separator=$'\x1F' \
    --title="Add bookmark" \
    --field="Name" "$input_name" \
    --field="URL" "$input_url" \
    --field="Tags!Tags should be space separated." ""\
    --button="OK":0 \
    --button="Cancel":1 \
    );
then
    exit 0
fi

# Process and validate the form input
#-------------------------------------------------------------------------------
new_bookmark_name=$(echo "$form_input" | cut -d $'\x1F' -f 1)
new_bookmark_url=$(echo "$form_input" | cut -d $'\x1F' -f 2)
new_bookmark_tags_raw=$(echo "$form_input" | cut -d $'\x1F' -f 3)

# Validate name.
if [[ -z "$new_bookmark_name" ]]; then
    err "Missing or bad input for bookmark name."
    exit 20
fi

new_bookmark_name_kebab=$(convert_to_kebab_case "$new_bookmark_name")

# Validate URL.
if [[ -z "$new_bookmark_url" ]]; then
    err "Missing or bad input for bookmark url."
    exit 21
fi

# Validate tags.
declare -a input_tags=()
declare -a new_bookmark_tags=()

IFS=' ' read -r -a input_tags <<< "$new_bookmark_tags_raw"

for t in "${input_tags[@]+"${input_tags[@]}"}"; do
    # TODO: Ignore duplicate tags.
    # Ignore 1-char tags and empty tags.
    if [[ "${#t}" -gt 1 ]] && [[ -n "$t"  ]]; then
        new_bookmark_tags+=("$(convert_to_kebab_case "$t")")
    fi
done

if [[ ${#new_bookmark_tags[@]} -eq 0 ]]; then
    err "Missing or bad input for bookmark tags."
    exit 22
fi

# Validate file path.
bookmark_file_path="$bookmark_dir/$new_bookmark_name_kebab.md"

# NOTE: Should we also check the URL being already being bookmarked?
if [[ -f "$bookmark_file_path" ]]; then
    err "Bookmark already exists: \`$bookmark_file_path\`"
    exit 23
fi

# Create a bookmark
#-------------------------------------------------------------------------------

if ! render-mako \
    "$bookmark_template" \
    "$bookmark_file_path" \
    new_bookmark_name="$new_bookmark_name" \
    new_bookmark_name_kebab="$new_bookmark_name_kebab" \
    new_bookmark_url="$new_bookmark_url" \
    new_bookmark_tags="${new_bookmark_tags[*]+"${new_bookmark_tags[*]}"}";  then
    err "Failed to create bookmark file: \`$bookmark_file_path\`"
    exit 30
fi
