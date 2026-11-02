#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# River utility functions.
#-------------------------------------------------------------------------------

# Construct a tag bitmask from a list of tags.
#
# Usage:
#   tagmask 1 2 3
# ------------------------------------------------------------------------------

function tagmask() {
    local mask=0

    for tag in "$@"; do
        mask=$(( mask | (1 << (tag - 1)) ))
    done

    echo $mask
}
