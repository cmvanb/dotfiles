#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Apply kebabcase formatting to a filename
#-------------------------------------------------------------------------------

set -euo pipefail

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/fs.sh"
# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/name-formatting.sh"

if [[ -f "$1" ]]; then
    src_filename="${1%.*}"
    src_file_ext="${1##*.}"
    dst_filename=$(convert_to_kebab_case "$src_filename")".$src_file_ext"

    happy_move "$1" "$dst_filename"
    echo "$1 -> $dst_filename"
elif [[ -d "$1" ]]; then
    dst_dirname=$(convert_to_kebab_case "$1")

    happy_move "$1" "$dst_dirname"
    echo "$1 -> $dst_dirname"
else
    echo "File or directory \`$1\` does not exist." 1>&2
    exit 1
fi
