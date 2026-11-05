#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Focus the next empty workspace on the focused output
#
# Searches below the focused workspace first, then wraps around from the top.
# niri keeps an empty workspace at the end of each output, so one always exists.
#-------------------------------------------------------------------------------

set -euo pipefail

# Dependencies
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

debug::assert_dependency niri
debug::assert_dependency jq

# Focus the workspace
#-------------------------------------------------------------------------------

idx=$(niri msg -j workspaces | jq -r '
    (.[] | select(.is_focused)) as $focused
    | [.[] | select(.output == $focused.output and .active_window_id == null and (.is_focused | not))]
    | sort_by(.idx)
    | (map(select(.idx > $focused.idx)) + .)
    | first.idx // empty')

[[ -n $idx ]] || exit 0

niri msg action focus-workspace "$idx"
