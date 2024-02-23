#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# View standard input in the pager, then print it to terminal on exit.
#-------------------------------------------------------------------------------

set -euo pipefail

# Read from stdin.
input=$(cat -)

# Count the lines in the input.
lines=$(echo "$input" | "$XDG_OPT_HOME/shell-utils/count-lines.sh")

# Get terminal height in lines.
terminal_height=$(( $(stty -F /dev/tty size | cut -d' ' -f1)-2 ))

# If the input is bigger than the viewport, page it.
[[ $lines -ge $terminal_height ]] && bat --paging=never --style=plain --wrap=never <(echo "$input") | less -c -R -S

# After paging (if it took place), print the whole input to the terminal.
bat --force-colorization --paging=never --style=plain <(echo "$input")
