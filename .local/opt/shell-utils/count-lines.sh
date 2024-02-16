#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Count the number of lines the terminal will need to render the input
#
#   NOTE: Does not account for lines more than twice the terminal's width.
#-------------------------------------------------------------------------------

set -euo pipefail

input=$(cat -)

columns=$(tput cols)
lines_count=$(echo "$input" | wc -l)
long_lines_count=$(echo "$input" | grep -c ".\{$columns\}" || true)
count=$(( lines_count + long_lines_count ))

echo "${count}"
