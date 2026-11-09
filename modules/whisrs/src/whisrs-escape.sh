#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Bind Escape to cancel dictation while whisrs records
#
# Called by the whisrs [hooks]. Sway switches to its dictation mode. Niri
# reloads an included binds file on change, so it is filled or emptied.
#-------------------------------------------------------------------------------

set -euo pipefail

niri_binds="${XDG_CONFIG_HOME:-$HOME/.config}/niri/dictation.kdl"

grab () {
    if [[ -n ${SWAYSOCK:-} ]]; then
        swaymsg --quiet mode dictation
    elif [[ -n ${NIRI_SOCKET:-} ]]; then
        printf 'binds {\n    Escape { spawn "whisrs" "cancel"; }\n}\n' > "$niri_binds"
    fi
}

release () {
    if [[ -n ${SWAYSOCK:-} ]]; then
        swaymsg --quiet mode default
    elif [[ -n ${NIRI_SOCKET:-} ]]; then
        : > "$niri_binds"
    fi
}

case ${1:-} in
    grab) grab ;;
    release) release ;;
    *) echo "Usage: whisrs-escape grab|release" >&2; exit 1 ;;
esac
