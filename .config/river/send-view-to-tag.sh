#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Send river view to a specific tag. If it's the last view on the current tag,
# focus the new tag.
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

# Tag view
#-------------------------------------------------------------------------------

# Remember source output
source_output=$(river-bedload -print outputs \
    | jq -r '.[] | select(.focused == true).name')

# Send view to tag
riverctl set-view-tags "$1"

# Count focused and occupied views on the source tag
source_tag_count=$(river-bedload -print tags \
    | jq -r --arg jq_source_output "$source_output" \
    'def count(s): reduce s as $_ (0;.+1); count(.[] | select(.output == $jq_source_output) | select(.focused == true and .occupied == true))')

# If the source tag has no focused and occupied views, focus the new tag
if [[ $source_tag_count -eq 0 ]]; then
    riverctl set-focused-tags "$1"
fi
