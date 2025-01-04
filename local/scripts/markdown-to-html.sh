#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Convert a markdown file to HTML.
#-------------------------------------------------------------------------------

set -o errexit
set -o pipefail
set -o nounset

if [ "$#" -ne 1 ]; then
    echo "Expected only one argument: the filename of the markdown file. Received $# arguments."
    exit 1
fi

file_name=$(basename -- "$1")
file_name="${file_name%.*}"
file_extension="${1##*.}"

if [ "$file_extension" != "md" ]; then
    echo "Expected markdown file with \`md\` extension. Received file with \`$file_extension\` extension."
    exit 1
fi

tmp_dir="/tmp/md"
mkdir -p "$tmp_dir"

pandoc -s -f markdown -t html --toc \
    --css "$XDG_DATA_HOME/pandoc/templates/github-pandoc.css" \
    "$1" > "$tmp_dir/$file_name.html"
