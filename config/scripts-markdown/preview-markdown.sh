#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Preview a markdown file in the browser.
#
# TODO: Kill the entr process when the browser is closed.
#-------------------------------------------------------------------------------

set -euo pipefail

if [ "$#" -ne 1 ]; then
    echo "Expected only one argument: the file name of the markdown file. Received $# arguments."
    exit 1
fi

file_name=$(basename -- "$1")
file_name="${file_name%.*}"
file_extension="${1##*.}"

if [ "$file_extension" != "md" ]; then
    echo "Expected markdown file with \`md\` extension. Received file with \`$file_extension\` extension."
    exit 1
fi

nohup echo "$1" | entr -r "$XDG_SCRIPTS_HOME/markdown-to-html.sh" "$1" >/dev/null 2>&1 &

html_path="/tmp/md/$file_name.html"
qutebrowser ":open $html_path"
