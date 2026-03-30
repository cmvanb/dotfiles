#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Spawn a command using the window manager's native spawn command.
#-------------------------------------------------------------------------------

set -euo pipefail

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

if [ "$#" -lt 1 ]; then
    echo "Usage: $(basename "$0") <command> [args...]" >&2
    echo "Example: $(basename "$0") alacritty" >&2
    echo "Example: $(basename "$0") qutebrowser --target window" >&2
    exit 1
fi

# Detect the window manager from XDG_CURRENT_DESKTOP
wm="${XDG_CURRENT_DESKTOP:-unknown}"

case "${wm,,}" in
    river)
        riverctl spawn "$@"
        ;;
    sway)
        swaymsg exec "$@"
        ;;
    hyprland)
        hyprctl dispatch exec "$@"
        ;;
    *)
        debug::error "Unsupported or unknown window manager: $wm — falling back to direct spawn"
        nohup "$@" >/dev/null 2>&1 &
        ;;
esac
