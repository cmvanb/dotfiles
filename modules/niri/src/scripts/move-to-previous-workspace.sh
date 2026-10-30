#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Move the focused window to the previous workspace, keeping focus
#
# Port of sway's `move container to workspace back_and_forth`. niri has no
# action for it, so the previous workspace is visited to learn its reference.
#-------------------------------------------------------------------------------

set -euo pipefail

# Dependencies
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

debug::assert_dependency niri
debug::assert_dependency jq

# Move the window
#-------------------------------------------------------------------------------

focused_workspace() {
    niri msg -j workspaces | jq -r '.[] | select(.is_focused) | [.idx, .output, .name // ""] | @tsv'
}

window_id=$(niri msg -j focused-window | jq -r '.id // empty')
[[ -n $window_id ]] || exit 0

current_output=$(focused_workspace | cut -f2)

niri msg action focus-workspace-previous
IFS=$'\t' read -r idx output name < <(focused_workspace)
niri msg action focus-workspace-previous

if [[ -n $name ]]; then
    niri msg action move-window-to-workspace --window-id "$window_id" --focus false "$name"
elif [[ $output == "$current_output" ]]; then
    niri msg action move-window-to-workspace --window-id "$window_id" --focus false "$idx"
else
    # An index resolves on the window's output, so cross outputs by monitor:
    # the previous workspace is the active one there.
    niri msg action move-window-to-monitor --id "$window_id" "$output"
    niri msg action focus-monitor "$current_output"
fi
