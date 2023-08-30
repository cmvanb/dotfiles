#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Choose a Qutebrowser session to load
#-------------------------------------------------------------------------------

if ! command -v wofi &> /dev/null; then
    echo "["$(basename "$0")"] ERROR: Missing dependency: wofi"
    exit 1
fi

if ! command -v qutebrowser &> /dev/null; then
    echo "["$(basename "$0")"] ERROR: Missing dependency: qutebrowser"
    exit 1
fi


data_dir="${XDG_DATA_HOME:-$HOME/.local/share}"
session_dir="$data_dir/qutebrowser/sessions"
session_files=$(fd ".yml" /home/surfer/.local/share/qutebrowser/sessions -x basename | sed -e 's/\.yml//' | sort)
session=$(echo "$session_files" | wofi --prompt "Open browser session" --show dmenu 2> /dev/null)

if [[ -z $session ]]; then
    exit 1
fi

qutebrowser --target window ":session-load $session" 2> /dev/null
