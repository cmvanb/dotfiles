#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Rename the focused workspace, keeping its numeric accessor
#
# Sway matches "workspace number N" / "move ... workspace number N" against
# the leading "N:" of a workspace's name (see workspace(5)), independent of
# the rest of the name. Renaming to "<num>:<new-name>" therefore keeps
# $mod+N switching working and preserves indexed ordering, while waybar's
# sway/workspaces {name} format strips the "N:" prefix and shows just the
# new name. Entering an empty name clears it back to the bare number.
#-------------------------------------------------------------------------------

set -euo pipefail

# Dependencies
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

debug::assert_dependency swaymsg
debug::assert_dependency jq

usage() {
    echo "$(basename "$0") [name]"
    echo "Rename the focused workspace, keeping its numeric accessor."
    echo "    With no arguments, prompts interactively via spawn-launcher.sh."
    echo "    With NAME given, renames non-interactively. An empty NAME clears"
    echo "    the workspace back to its bare number."
    exit 1
}

[[ $# -gt 1 ]] && usage

# Rename the focused workspace
#-------------------------------------------------------------------------------

focused_num=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused) | .num')

if [[ $# -eq 1 ]]; then
    new_name="$1"
else
    debug::assert_dependency spawn-launcher.sh
    new_name=$(spawn-launcher.sh --menu --prompt="Rename workspace $focused_num..." < /dev/null) || exit 0
fi

if [[ -z "$new_name" ]]; then
    swaymsg rename workspace to "$focused_num"
else
    swaymsg rename workspace to "$focused_num:$new_name"
fi
