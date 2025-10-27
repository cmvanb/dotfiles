#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Sway workspace switcher
#
# TODO: don't hardcode outputs
#-------------------------------------------------------------------------------

set -euo pipefail

if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <action> <workspace_number>"
    echo "  action: 'focus' or 'move'"
    echo "  workspace_number: 1-10"
    exit 1
fi

action="$1"
workspace_num="$2"

focused_output=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')


case "$focused_output" in
    "DP-3"|"LG Electronics LG ULTRAWIDE 405NTPC4A128")
        workspace_name="${workspace_num}"
        ;;
    "HDMI-A-6 | eDP-1")
        workspace_name="1${workspace_num}"
        ;;
    "DP-4")
        workspace_name="2${workspace_num}"
        ;;

    *)
        workspace_name="${workspace_num}"
        ;;
esac

case "$action" in
    "focus")
        swaymsg workspace "$workspace_name"
        ;;
    "move")
        swaymsg move container to workspace "$workspace_name"
        ;;
    *)
        echo "Invalid action: $action"
        exit 1
        ;;
esac
