#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Eww bar launcher
#
# Usage: eww-bar.sh start     # open a bar on every output, follow hotplug
#        eww-bar.sh toggle    # hide or show the bars
#        eww-bar.sh restart   # restart the eww daemon and the bars
#
# `start` keeps running: it follows the window manager's output events and
# opens or closes a bar per output as monitors come and go. Hidden state
# survives hotplug events.
#-------------------------------------------------------------------------------

set -uo pipefail

runtime_dir="${XDG_RUNTIME_DIR:-/tmp}/eww"
wm="${XDG_CONFIG_HOME:-$HOME/.config}/eww/scripts/wm.sh"
hidden_flag="$runtime_dir/bar-hidden"
pid_file="$runtime_dir/bar.pid"

active_outputs() {
    "$wm" outputs
}

open_bars() {
    eww active-windows 2>/dev/null | awk -F: '$2 ~ /^ *bar$/ { print $1 }'
}

reconcile() {
    local output id
    local -a wanted=()

    if [[ ! -e $hidden_flag ]]; then
        mapfile -t wanted < <(active_outputs)
    fi

    for id in $(open_bars); do
        [[ " ${wanted[*]} " == *" ${id#bar-} "* ]] || eww close "$id" &> /dev/null
    done

    for output in "${wanted[@]}"; do
        open_bars | grep -qx "bar-$output" && continue
        eww open bar --id "bar-$output" --screen "$output" --arg output="$output" &> /dev/null
    done
}

start() {
    mkdir -p "$runtime_dir"
    rm -f "$hidden_flag"

    # Replace a previous instance (e.g. after a window manager reload).
    [[ -f $pid_file ]] && kill "$(<"$pid_file")" 2>/dev/null
    echo $$ > "$pid_file"

    eww ping &> /dev/null || eww daemon
    until eww ping &> /dev/null; do sleep 0.1; done

    exec {events}< <("$wm" output-events)
    local subscriber=$!
    trap 'kill "$subscriber" 2>/dev/null; exit 0' TERM INT

    reconcile
    while read -r -u "$events" _; do
        reconcile
    done
}

case ${1:-} in
    start)
        start
        ;;

    toggle)
        mkdir -p "$runtime_dir"
        if [[ -e $hidden_flag ]]; then
            rm -f "$hidden_flag"
        else
            touch "$hidden_flag"
            "${XDG_CONFIG_HOME:-$HOME/.config}/eww/scripts/popup.sh" close
        fi
        reconcile
        ;;

    restart)
        eww kill &> /dev/null
        nohup "$0" start &> /dev/null &
        ;;

    *)
        echo "Usage: $(basename "$0") start | toggle | restart" >&2
        exit 1
        ;;
esac
