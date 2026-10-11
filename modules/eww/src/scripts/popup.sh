#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Eww popup controller
#
# Usage: popup.sh toggle <name> <output> [view]  # open <name> on <output>, or close it
#        popup.sh close                           # close any open popup
#        popup.sh leave                           # close soon, unless the pointer is on it
#        popup.sh watch                           # internal: run `leave` on window focus
#
# Layer-shell popups never hold keyboard focus under sway, so eww's
# `unfocus-close` cannot dismiss them. Instead a popup closes shortly after the
# pointer leaves it or another window takes focus, unless the pointer is over
# the popup by then.
#-------------------------------------------------------------------------------

set -uo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
runtime_dir="${XDG_RUNTIME_DIR:-/tmp}/eww"
watch_pid="$runtime_dir/popup-watch.pid"
grace=0.6

# The watcher runs in its own process group so one signal stops the whole
# pipeline. This may include the calling `leave`, so it runs last.
stop_watch() {
    local pid
    pid=$(cat "$watch_pid" 2>/dev/null) || return 0
    rm -f "$watch_pid"
    kill -- "-$pid" 2>/dev/null
}

close() {
    if eww active-windows 2>/dev/null | grep -q '^popup:'; then
        eww close popup &> /dev/null
    fi
    eww update popup="" popup_hover=false
    stop_watch
}

start_watch() {
    mkdir -p "$runtime_dir"
    setsid "$script_dir/popup.sh" watch &> /dev/null &
    echo $! > "$watch_pid"
}

prepare() {
    case $1 in
        calendar) eww update calendar="$("$script_dir/month-grid.py" "${2:-month}" 0)" ;;
    esac
}

case ${1:-} in
    toggle)
        name=$2
        output=$3
        current=$(eww get popup 2>/dev/null)
        open=$(eww active-windows 2>/dev/null | grep -c '^popup:')

        close
        if [[ $current == "$name" && $open -gt 0 ]]; then
            exit 0
        fi

        prepare "$name" "${4:-}"
        eww update popup="$name"
        eww open popup --screen "$output" --arg name="$name" &> /dev/null
        start_watch
        ;;

    close)
        close
        ;;

    # Any window focus change (e.g. focus following the pointer onto a window)
    # starts the leave grace period.
    watch)
        swaymsg -r -m -t subscribe '["window"]' 2>/dev/null \
            | grep --line-buffered '"change": *"focus"' \
            | while read -r _; do "$script_dir/popup.sh" leave & done
        ;;

    leave)
        sleep "$grace"
        [[ $(eww get popup_hover 2>/dev/null) == true ]] || close
        ;;

    *)
        echo "Usage: $(basename "$0") toggle <name> <output> [view] | close | leave | watch" >&2
        exit 1
        ;;
esac
