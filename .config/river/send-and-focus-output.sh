#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Send river view to a specific output and focus its tag
#-------------------------------------------------------------------------------

# Imports
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

# Validation
#-------------------------------------------------------------------------------

assert_dependency jq
assert_dependency river-bedload
assert_dependency riverctl

# Send view and focus it
#-------------------------------------------------------------------------------

# Remember source output and tag
source_output=$(river-bedload -print outputs | jq -r '.[] | select(.focused == true).name')
source_tag=$(river-bedload -print focused | jq -r --arg jq_source_output "$source_output" '.[] | select(.output == $jq_source_output).focused_id')

# Send view and focus output
riverctl send-to-output "$1"
riverctl focus-output "$1"

# Focus tag
declare tags=$(( 1 << (source_tag - 1) ))
riverctl set-focused-tags $tags
