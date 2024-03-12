#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Open a file from LF
#-------------------------------------------------------------------------------

set -euo pipefail

# Imports
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/fs.sh"

# Validation
#-------------------------------------------------------------------------------

if [[ -z "$1" ]]; then
    echo "[$(basename "$0")] ERROR: Missing argument: file name"
    exit 1
fi

# Open file
#-------------------------------------------------------------------------------

mimetype="$(file_mime_type "$1")"
encoding=$(file_encoding "$1")

if [[ $mimetype == "text"* || $mimetype == "application/javascript" || $encoding == *"ascii" || $encoding == "utf-8" ]]; then
    "$XDG_SCRIPTS_HOME/set-terminal-title.sh" "${1/$HOME/\~}"

    formatted=$("$XDG_SCRIPTS_HOME/format-text.sh" "$1")

    bat --force-colorization --style=numbers --paging=never --wrap=never <(echo "$formatted") \
        | less -c -R --chop-long-lines --lesskey-file="$XDG_CONFIG_HOME/lf/lf-less.lesskey"

    "$XDG_SCRIPTS_HOME/set-terminal-title.sh" "${PWD/$HOME/\~}"

else
    nohup xdg-open "$1" > /dev/null 2>&1 &

fi
