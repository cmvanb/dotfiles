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

fq_path=$(realpath -- "$1")
header=$(grep -m1 -E '^# ' "$1" | sed -E 's/^#[[:space:]]+//') || true
if [ -n "$header" ]; then
    page_title="$header ($fq_path)"
else
    page_title="$fq_path"
fi

# Render to a temp file first: a pandoc/mermaid-filter failure (e.g. invalid
# diagram syntax) must not truncate the last good preview to empty.
tmp_html="$tmp_dir/$file_name.html.tmp"

# mermaid-filter drops a "mermaid-filter.err" file in the working directory,
# so run pandoc from $tmp_dir to keep it out of the source tree.
(
    cd "$tmp_dir" &&
    PUPPETEER_EXECUTABLE_PATH=$(command -v chromium) \
    MERMAID_FILTER_FORMAT=svg \
    MERMAID_FILTER_THEME=dark \
    MERMAID_FILTER_BACKGROUND=transparent \
    pandoc -s -f markdown+alerts+emoji+autolink_bare_uris+hard_line_breaks-implicit_figures -t html --toc \
        --embed-resources \
        --resource-path "$(dirname "$fq_path")" \
        --syntax-highlighting "$XDG_CONFIG_HOME/theme/carbon-dark.pygments.theme" \
        --css "$XDG_DATA_HOME/pandoc/templates/markdown.css" \
        --metadata pagetitle="$page_title" \
        --filter mermaid-filter \
        "$fq_path"
) | python3 "$XDG_SCRIPTS_HOME/svg-inject-style.py" > "$tmp_html"

mv "$tmp_html" "$tmp_dir/$file_name.html"
