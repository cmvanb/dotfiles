#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Niri named workspaces
#
# Focuses a named workspace or moves a window to it, creating it on demand like
# sway does. A new named workspace takes the trailing empty workspace of the
# output its slot in $XDG_CONFIG_HOME/niri/workspaces resolves to. Slots index
# the connected outputs: outputs missing from output-order first, then the
# outputs in that file. workspaces.sh removes named workspaces once they are
# empty and hidden.
#-------------------------------------------------------------------------------

set -euo pipefail

# Dependencies
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

debug::assert_dependency niri
debug::assert_dependency jq
debug::assert_dependency flock

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/niri"
workspaces_file="$config_dir/workspaces"
order_file="$config_dir/output-order"
# Shared with workspaces.sh, which holds off reaping while a workspace is set up.
lock_file="${XDG_RUNTIME_DIR:-/tmp}/niri-workspaces.lock"

usage() {
    echo "$(basename "$0") <focus|move> <name> [--window-id ID]"
    echo "Options:"
    echo "    focus NAME                 Focus the named workspace."
    echo "    move NAME [--window-id ID] Move the focused window, or window ID, to it."
    exit 1
}

# Resolve the output of a named workspace
#-------------------------------------------------------------------------------

slot_of() {
    awk -v name="$1" '!/^\s*#/ && $1 == name { print $2; exit }' "$workspaces_file"
}

read_order() {
    if [[ -f $order_file ]]; then
        grep -v '^\s*#' "$order_file" | grep -v '^\s*$'
    fi
}

ordered_outputs() {
    local -a orders=() connected=()
    local output

    mapfile -t orders < <(read_order)
    mapfile -t connected < <(niri msg -j outputs | jq -r '.[] | select(.logical != null) | .name' | sort)

    for output in "${connected[@]}"; do
        [[ " ${orders[*]} " == *" $output "* ]] || echo "$output"
    done

    for output in "${orders[@]}"; do
        [[ " ${connected[*]} " == *" $output "* ]] && echo "$output"
    done

    return 0
}

output_of_slot() {
    local -a outputs=()
    mapfile -t outputs < <(ordered_outputs)

    local slot=$1
    (( slot < ${#outputs[@]} )) || slot=$(( ${#outputs[@]} - 1 ))
    echo "${outputs[$slot]}"
}

# Workspace queries
#-------------------------------------------------------------------------------

workspace_exists() {
    niri msg -j workspaces | jq -e --arg name "$1" 'any(.[]; (.name // "" | ascii_downcase) == ($name | ascii_downcase))' > /dev/null
}

trailing_workspace_idx() {
    niri msg -j workspaces | jq -r --arg output "$1" \
        '[.[] | select(.output == $output and .name == null and .active_window_id == null)] | max_by(.idx) | .idx'
}

focused_output() {
    niri msg -j focused-output | jq -r '.name'
}

# Name the trailing empty workspace of an output
#
# niri resolves a workspace index on the focused output, so the target output
# is focused first. Focus stays on that output.
#-------------------------------------------------------------------------------

create_workspace() {
    local name=$1 focus=$2
    local output idx

    output=$(output_of_slot "$(slot_of "$name")")
    [[ $output == "$(focused_output)" ]] || niri msg action focus-monitor "$output"
    idx=$(trailing_workspace_idx "$output")

    if [[ $focus == "true" ]]; then
        niri msg action focus-workspace "$idx"
        niri msg action set-workspace-name "$name"
    else
        niri msg action set-workspace-name --workspace "$idx" "$name"
    fi
}

# Actions
#-------------------------------------------------------------------------------

ws_focus() {
    local name=$1

    if workspace_exists "$name"; then
        niri msg action focus-workspace "$name"
    else
        create_workspace "$name" true
    fi
}

ws_move() {
    local name=$1 window_id=$2

    if [[ -z $window_id ]]; then
        window_id=$(niri msg -j focused-window | jq -r '.id // empty')
        [[ -n $window_id ]] || exit 0
    fi

    if ! workspace_exists "$name"; then
        local previous_output
        previous_output=$(focused_output)

        create_workspace "$name" false
        niri msg action move-window-to-workspace --window-id "$window_id" --focus false "$name"
        niri msg action focus-monitor "$previous_output"
    else
        niri msg action move-window-to-workspace --window-id "$window_id" --focus false "$name"
    fi
}

# Dispatch
#-------------------------------------------------------------------------------

[[ $# -ge 2 ]] || usage

action=$1
name=$2
window_id=""

if [[ $# -eq 4 && $3 == "--window-id" ]]; then
    window_id=$4
elif [[ $# -ne 2 ]]; then
    usage
fi

# Existing names include names given by rename-workspace.sh.
if ! workspace_exists "$name" && [[ -z $(slot_of "$name") ]]; then
    debug::error_notify "Unknown workspace name: $name"
    exit 1
fi

exec {lock_fd}> "$lock_file"
flock "$lock_fd"

case "$action" in
    focus)
        ws_focus "$name"
        ;;
    move)
        ws_move "$name" "$window_id"
        ;;
    *)
        usage
        ;;
esac
