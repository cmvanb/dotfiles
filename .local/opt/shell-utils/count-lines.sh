#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Count the number of lines the terminal will need to render the input
#
#   NOTE: Does not account for lines more than twice the terminal's width.
#-------------------------------------------------------------------------------

# NOTE: Filter out terminal escapes to avoid counting them towards line length.
input=$(cat - | sed 's/[^[:print:]]\[[^a-zA-Z]*[a-zA-Z]//g')

columns=$(stty -F /dev/tty size | cut -d' ' -f2)
lines_count=$(echo "$input" | wc -l)
long_lines_count=$(echo "$input" | grep -c ".\{$columns\}" || true)
count=$(( lines_count + long_lines_count ))

echo "${count}"
