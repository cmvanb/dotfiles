#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Preview a markdown file in the browser with live reload.
#
# Starts a self-contained background server that watches the file with entr
# and shuts everything down when the browser tab is closed. The script itself
# exits immediately after opening the browser.
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

html_path="/tmp/md/$file_name.html"

# Run an initial conversion so the file is ready before the browser opens.
"$XDG_SCRIPTS_HOME/markdown-to-html.sh" "$1"

# Delegate everything else to the server, which daemonizes itself.
# It prints the chosen port to stdout before forking into the background.
port=$(python3 "$XDG_SCRIPTS_HOME/preview-server.py" \
    "$1" "$html_path" "$XDG_SCRIPTS_HOME/markdown-to-html.sh")

"$XDG_SCRIPTS_HOME/browse.sh" "http://localhost:$port"
