#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Open a file from LF
#-------------------------------------------------------------------------------

set -euo pipefail

if ! command -v file &> /dev/null; then
    echo "["$(basename "$0")"] ERROR: Missing dependency: file"
    exit 1
fi

if [[ -z "$1" ]]; then
    echo "[$(basename "$0")] ERROR: Missing argument: file name"
    exit 1
fi

mime="$(file -b --mime-type "$(realpath "$1")")"

# TODO: Improve file type detection.
if [[ "$mime" =~ "text" || "$mime" == "application/json" ]]; then
    $XDG_SCRIPTS_HOME/set-terminal-title.sh "$(echo "$1" | sed "s|$HOME|~|")"
    $XDG_SCRIPTS_HOME/terminal-preview.sh $1 | less -R --lesskey-file=$XDG_CONFIG_HOME/lf/lf-less.lesskey
    $XDG_SCRIPTS_HOME/set-terminal-title.sh "$(pwd | sed "s|$HOME|~|")"
else
    xdg-open $1 &
fi
