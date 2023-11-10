#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Get the transform of a wayland output.
#-------------------------------------------------------------------------------

set -uo pipefail

output=$(wlr-randr | grep -m1 -n -w "$1")

if [[ -z $output ]]; then
    echo "ERROR: output named \`$1\` not found"
    exit 1
fi

# Find the line number on which the display info begins.
line_number=$(echo "$output" | cut -d: -f1)

# Tail the output from that line and match the first `Transform` line, then slice that match on spaces.
transform=($(wlr-randr | tail -n +"$line_number" | awk '/Transform/{print $line; exit}'))

# Print the second item in the array
echo "${transform[1]}"
