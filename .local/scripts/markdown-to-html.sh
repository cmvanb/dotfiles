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

filename=$(basename -- "$1")
extension="${filename##*.}"

if [ "$extension" != "md" ]; then
    echo "Expected markdown file with \`md\` extension. Received file with \`$extension\` extension."
    exit 1
fi

outname="${filename%.*}.html"

pandoc -s -f markdown -t html --toc --css $XDG_DATA_HOME/pandoc/templates/github-pandoc.css $filename > $outname
