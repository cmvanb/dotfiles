#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Open a file from LF
#-------------------------------------------------------------------------------

set -euo pipefail

# Imports
#-------------------------------------------------------------------------------

source $XDG_SCRIPTS_HOME/fs-utils.sh

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
    $XDG_SCRIPTS_HOME/set-terminal-title.sh "$(echo "$1" | sed "s|$HOME|~|")"
    $XDG_SCRIPTS_HOME/terminal-preview.sh $1 | less -R --chop-long-lines --lesskey-file=$XDG_CONFIG_HOME/lf/lf-less.lesskey
    $XDG_SCRIPTS_HOME/set-terminal-title.sh "$(pwd | sed "s|$HOME|~|")"
else
    xdg-open $1 &
fi
