#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# View a text file in the pager, then print it to terminal on exit.
#-------------------------------------------------------------------------------

set -euo pipefail

# Count the lines in the file.
lines=$(wc -l < "$1")

# Get terminal height in lines.
# NOTE: `-2` is the magic offset.
terminal_height=$(( $(tput lines)-2 ))

# If the file is bigger than the viewport, page it.
[[ $lines -ge $terminal_height ]] && bat --force-colorization --paging=never --style=numbers --wrap=never "$1" | less -c -R -S

# After paging (if it took place), print the whole file to the terminal.
bat --force-colorization --paging=never --style=numbers --wrap=never "$1"
