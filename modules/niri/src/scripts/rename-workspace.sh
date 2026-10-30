#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Rename the focused workspace
#
# niri keeps the index of a named workspace, so $mod+N switching keeps working.
# Entering an empty name clears the name. workspaces.sh removes a named
# workspace once it is empty and hidden, like sway does.
#-------------------------------------------------------------------------------

set -euo pipefail

# Dependencies
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

debug::assert_dependency niri
debug::assert_dependency jq

usage() {
    echo "$(basename "$0") [name]"
    echo "Rename the focused workspace."
    echo "    With no arguments, prompts interactively via spawn-launcher.sh."
    echo "    With NAME given, renames non-interactively. An empty NAME clears"
    echo "    the name."
    exit 1
}

[[ $# -gt 1 ]] && usage

# Rename the focused workspace
#-------------------------------------------------------------------------------

workspaces=$(niri msg -j workspaces)
focused_idx=$(jq -r '.[] | select(.is_focused) | .idx' <<< "$workspaces")

if [[ $# -eq 1 ]]; then
    new_name="$1"
else
    debug::assert_dependency spawn-launcher.sh
    new_name=$(spawn-launcher.sh --menu --prompt="Rename workspace $focused_idx..." < /dev/null) || exit 0
fi

if [[ -z "$new_name" ]]; then
    niri msg action unset-workspace-name
    exit 0
fi

# niri silently ignores a name that another workspace already holds, ignoring case.
if jq -e --arg name "$new_name" 'any(.[]; (.name // "" | ascii_downcase) == ($name | ascii_downcase) and (.is_focused | not))' <<< "$workspaces" > /dev/null; then
    debug::error_notify "Workspace name '$new_name' is already taken."
    exit 1
fi

niri msg action set-workspace-name "$new_name"
