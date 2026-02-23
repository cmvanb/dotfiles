#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Sway workspace switcher
#
# Performs display-aware workspace switching. Reads the output offset map
# written by outputs-workspace-mapper.sh to translate the pressed number (1-10)
# into the correct workspace for the focused output.
#
#   primary output   → workspaces 1-10   (offset 0)
#   secondary output → workspaces 11-20  (offset 10)
#   tertiary output  → workspaces 21-30  (offset 20)
#
# State file: $XDG_STATE_HOME/sway/outputs-workspace-map
#   Format: "output_name:offset" per line
#-------------------------------------------------------------------------------

set -euo pipefail

if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <action> <workspace_number>"
    echo "  action: 'focus' or 'move'"
    echo "  workspace_number: 1-10, or named workspace"
    exit 1
fi

action="$1"
target_workspace="$2"

state_file="${XDG_STATE_HOME:-$HOME/.local/state}/sway/outputs-workspace-map"

if [[ "$target_workspace" =~ ^[0-9]+$ ]]; then
    focused_output=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')
    offset=$(grep -m1 "^${focused_output}:" "$state_file" 2>/dev/null | cut -d: -f2)
    offset=${offset:-0}
    workspace_name=$(( target_workspace + offset ))
else
    workspace_name="$target_workspace"
fi

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
