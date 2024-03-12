#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# View text from standard input.
#
# The pager will be invoked if the text has more lines than the terminal has
# vertical space.
#-------------------------------------------------------------------------------

set -euo pipefail

input=$(cat -)

lines=$(echo "$input" | "$XDG_OPT_HOME/shell-utils/count-lines.sh")

terminal_height=$(( $(stty -F /dev/tty size | cut -d' ' -f1)-2 ))

if [[ $lines -ge $terminal_height ]]; then
    bat --force-colorization --style=plain --paging=never --wrap=never <(echo "$input") \
        | less -c -R -S

else
    bat --force-colorization --style=plain --paging=never --wrap=never <(echo "$input")

fi
