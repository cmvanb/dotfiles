#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Check whether a wayland output exists (status code 0 == true, 1 == false).
#-------------------------------------------------------------------------------

set -uo pipefail

output=$(wlr-randr | grep -m1 -n -w "$1")

if [[ -z $output ]]; then
    echo "ERROR: output named \`$1\` not found"
    exit 1
fi
