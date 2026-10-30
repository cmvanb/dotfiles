#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Window manager boundary for eww
#
# Usage: wm.sh listen                          # print bar state JSON per change
#        wm.sh outputs                         # active output names
#        wm.sh output-events                   # one line per output change
#        wm.sh focus-events                    # one line per window focus change
#        wm.sh focus-workspace <output> <ref>  # focus a workspace from the bar
#        wm.sh open-pavucontrol                # open the audio mixer
#
# The backend is niri when NIRI_SOCKET is set, else sway.
#-------------------------------------------------------------------------------

set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"

# Dependencies
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

if [[ -n ${NIRI_SOCKET:-} ]]; then
    wm=niri
    debug::assert_dependency niri
else
    wm=sway
    debug::assert_dependency swaymsg
    debug::assert_dependency jq
fi

# Commands
#-------------------------------------------------------------------------------

sway::listen() { exec "$script_dir/sway.py"; }
niri::listen() { exec "$script_dir/niri.py"; }

sway::outputs() {
    swaymsg -t get_outputs 2>/dev/null | jq -r '.[] | select(.active) | .name'
}
niri::outputs() {
    niri msg -j outputs 2>/dev/null | jq -r '.[] | select(.logical) | .name'
}

sway::output-events() {
    exec swaymsg -r -m -t subscribe '["output"]' 2>/dev/null
}
# Output hotplug moves workspaces between outputs.
niri::output-events() {
    exec grep --line-buffered '^{"WorkspacesChanged"' < <(niri msg -j event-stream 2>/dev/null)
}

sway::focus-events() {
    exec grep --line-buffered '"change": *"focus"' < <(swaymsg -r -m -t subscribe '["window"]' 2>/dev/null)
}
niri::focus-events() {
    exec grep --line-buffered '^{"WindowFocusChanged"' < <(niri msg -j event-stream 2>/dev/null)
}

sway::focus-workspace() {
    swaymsg "workspace \"$2\"" > /dev/null
}
niri::focus-workspace() {
    niri msg action focus-monitor "$1"
    niri msg action focus-workspace "$2"
}

sway::open-pavucontrol() { exec "$config_dir/sway/scripts/open-pavucontrol.sh"; }
niri::open-pavucontrol() { exec "$config_dir/niri/scripts/open-pavucontrol.sh"; }

case ${1:-} in
    listen | outputs | output-events | focus-events | open-pavucontrol)
        "$wm::$1"
        ;;

    focus-workspace)
        [[ $# -eq 3 ]] || { echo "Usage: $(basename "$0") focus-workspace <output> <ref>" >&2; exit 1; }
        "$wm::$1" "$2" "$3"
        ;;

    *)
        echo "Usage: $(basename "$0") listen | outputs | output-events | focus-events | focus-workspace <output> <ref> | open-pavucontrol" >&2
        exit 1
        ;;
esac
