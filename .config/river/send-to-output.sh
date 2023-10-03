#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Send river window to a specific output
#-------------------------------------------------------------------------------

# Imports
#-------------------------------------------------------------------------------

source $XDG_SCRIPTS_HOME/debug-utils.sh

# Validation
#-------------------------------------------------------------------------------

assert_dependency wofi
assert_dependency riverctl

# Choose output
#-------------------------------------------------------------------------------

outputs="$($XDG_SCRIPTS_HOME/wl-get-outputs.sh)"
target=$(echo "$outputs" | wofi --prompt "Send to output" --show dmenu 2> /dev/null)

if [[ -z $target ]]; then
    exit 1
fi

# Send window to output
#-------------------------------------------------------------------------------

riverctl send-to-output $target
riverctl focus-output $target
