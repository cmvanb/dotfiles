#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Send river window to a specific output
#-------------------------------------------------------------------------------

# Imports
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"
# shellcheck disable=SC1091
source "$XDG_OPT_HOME/wayland-utils/output.sh"

# Validation
#-------------------------------------------------------------------------------

assert_dependency fuzzel
assert_dependency riverctl

# Choose output
#-------------------------------------------------------------------------------

outputs="$(wl_get_outputs)"
target=$(echo "$outputs" | fuzzel --dmenu 2> /dev/null)

if [[ -z $target ]]; then
    exit 1
fi

# Send window to output
#-------------------------------------------------------------------------------

riverctl send-to-output "$target"
riverctl focus-output "$target"
