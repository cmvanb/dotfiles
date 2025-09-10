#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Choose a Qutebrowser session to load
#-------------------------------------------------------------------------------

# Imports
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

# Validation
#-------------------------------------------------------------------------------

assert_dependency spawn-launcher.sh
assert_dependency qutebrowser

# Choose Qutebrowser session
#-------------------------------------------------------------------------------

data_dir="${XDG_DATA_HOME:-$HOME/.local/share}"
session_dir="$data_dir/qutebrowser/sessions"
session_files=$(fd ".yml" "$session_dir" -x basename | sed -e 's/\.yml//' | sort)
session=$(echo "$session_files" | spawn-launcher.sh --menu --prompt="Open browser session..." 2> /dev/null)

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
