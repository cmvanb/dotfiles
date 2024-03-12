#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Format a text file for viewing in the terminal.
#-------------------------------------------------------------------------------

set -euo pipefail

# Imports
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/fs.sh"

# Functions
#-------------------------------------------------------------------------------

format_json() {
    declare json

    if json=$(jq --indent 4 --color-output . "$1"); then
        echo "$json"
        return 0
    fi

    return 1
}

# Formatting is based on file type and extension.
#-------------------------------------------------------------------------------

mimetype=$(file_mime_type "$1")
extension=$(file_extension "$1")

if [[ $mimetype == "application/json" ]] || [[ $mimetype == "text/plain" && $extension == "json" ]]; then
    format_json "$1"

else
    bat --force-colorization --style=plain --paging=never --wrap=never "$1"

fi
