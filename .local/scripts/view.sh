#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# View text in the terminal. If the text is too wide or too tall, page it.
#-------------------------------------------------------------------------------

set -euo pipefail

# stdin is a tty: Process command line arguments.
if [ -t 0 ]; then
    file_name="$1"

    input="$("$XDG_SCRIPTS_HOME/format-text.sh" "$file_name")"
    input_width="$(wc -L "$file_name" | cut -d' ' -f1)"

# stdin is not a tty: Process standard input.
else
    stdin="$(cat)"

    input="$stdin"
    input_width="$(echo "$stdin" | "$XDG_OPT_HOME/shell-utils/strip-ansi.sh" | wc -L)"
fi

input_lines=$(echo "$input" | "$XDG_OPT_HOME/shell-utils/count-lines.sh")

terminal_height=$(( $(stty -F /dev/tty size | cut -d' ' -f1)-1 ))
terminal_width=$(( $(stty -F /dev/tty size | cut -d' ' -f2)-1 ))

# If the text is too wide or too tall, page it.
if [[ $input_lines -gt $terminal_height || $input_width -gt $terminal_width ]]; then
    bat --force-colorization --style=plain --paging=never --wrap=never <(echo "$input") \
        | less -c -R -S

# Otherwise, display the text in the terminal.
else
    bat --force-colorization --style=plain --paging=never --wrap=never <(echo "$input")

fi
