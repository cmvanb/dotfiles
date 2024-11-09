#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Focus a niri window
#-------------------------------------------------------------------------------

# Imports
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

# Validation
#-------------------------------------------------------------------------------

assert_dependency jq
assert_dependency niri
assert_dependency wofi

# Focus window
#-------------------------------------------------------------------------------

windows=$(niri msg --json windows)

# TODO: Improve window name formatting.
# TODO: Add app icons.

selected=$(echo "$windows" \
    | jq -r '.[] | "\(.id) [\(.app_id)]  \(.title)"' \
    | wofi --dmenu --insensitive --prompt "Focus window..." 2> /dev/null \
    | awk '{print $1}')

niri msg action focus-window --id "$selected"
