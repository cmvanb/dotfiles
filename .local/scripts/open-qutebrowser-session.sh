#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Choose a Qutebrowser session to load
#-------------------------------------------------------------------------------

set -euo pipefail

# Imports
#-------------------------------------------------------------------------------

source $XDG_SCRIPTS_HOME/debug-utils.sh

# Validation
#-------------------------------------------------------------------------------

assert_dependency wofi
assert_dependency qutebrowser

# Choose Qutebrowser session
#-------------------------------------------------------------------------------

data_dir="${XDG_DATA_HOME:-$HOME/.local/share}"
session_dir="$data_dir/qutebrowser/sessions"
session_files=$(fd ".yml" /home/surfer/.local/share/qutebrowser/sessions -x basename | sed -e 's/\.yml//' | sort)
session=$(echo "$session_files" | wofi --prompt "Open browser session" --show dmenu 2> /dev/null)

if [[ -z $session ]]; then
    exit 1
fi

# Open Qutebrowser session
#-------------------------------------------------------------------------------

if pgrep qutebrowser; then
    qutebrowser --target window ":session-load $session"
else
    qutebrowser --target window --restore "$session"
fi
