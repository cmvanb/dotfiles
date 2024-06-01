#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Count command usage in the history file.
#
# Usage:
#  count-command-usage.sh <file_name>
#  <stdin> | count-command-usage.sh
#-------------------------------------------------------------------------------

set -euo pipefail

# stdin is a tty: Process command line arguments.
if [ -t 0 ]; then
    file_name="$1"

    input="$(cat "$file_name")"

# stdin is not a tty: Process standard input.
else
    input="$(cat)"

fi

declare -A command_counts

# Iterate over each line in the input.
while IFS= read -r line; do
    # Extract the first word from the line.
    command="$(echo "$line" | cut -d' ' -f1)"

    if [[ -z "$command" ]]; then
        continue
    fi

    if [[ -v command_counts["$command"] ]]; then
        :
    else
        command_counts["$command"]=0
    fi

    # Increment the count for the command.
    command_counts["$command"]=$((command_counts["$command"] + 1))

done <<< "$input"

# Output the command counts.
declare command_count_output="/tmp/command_count_output"

for command in "${!command_counts[@]}"; do
    count="${command_counts["$command"]}"
    printf "%s: %s \n" "$command" "$count" >> "$command_count_output"
done

# Reverse, numeric sort by second column, with space as the delimiter.
sort -n -r -k2 -t' ' "$command_count_output"

# Remove the temporary file.
rm "$command_count_output"
