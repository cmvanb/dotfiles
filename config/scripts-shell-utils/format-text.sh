#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Format a text file for viewing in the terminal.
#-------------------------------------------------------------------------------

set -uo pipefail

# Imports
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/fs.sh"

# Functions
#-------------------------------------------------------------------------------

format_json() {
    declare json
    json=$(jq --indent 4 --color-output . "$1" 2> /dev/null)
    if [[ $? -ne 0 ]]; then
        return 1
    fi

    echo "$json"
}

# Formatting is based on file type and extension.
#-------------------------------------------------------------------------------

mimetype=$(file_mime_type "$1")
extension=$(file_extension "$1")

if [[ $mimetype == "application/json" ]] || [[ $mimetype == "text/plain" && $extension == "json" ]]; then
    format_json "$1"
    if [ $? -ne 0 ]; then
        bat --force-colorization --style=plain --paging=never --wrap=never "$1"
    fi
else
    bat --force-colorization --style=plain --paging=never --wrap=never "$1"
fi
