#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Convert a markdown file to HTML whenever it changes.
#-------------------------------------------------------------------------------

set -euo pipefail

if [ "$#" -ne 1 ]; then
    echo "Expected only one argument: the filename of the markdown file. Received $# arguments."
    exit 1
fi

filename=$(basename -- "$1")
extension="${filename##*.}"

if [ "$extension" != "md" ]; then
    echo "Expected markdown file with \`md\` extension. Received file with \`$extension\` extension."
    exit 1
fi

echo "$1" | entr -r "$XDG_SCRIPTS_HOME/markdown-to-html.sh" "$1"
