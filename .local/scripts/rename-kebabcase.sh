#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Apply kebabcase formatting to a filename
#-------------------------------------------------------------------------------

set -euo pipefail

source $XDG_SCRIPTS_HOME/name-formatting.sh

function try_move() {
    # NOTE: `mv` returns an error code if the source and destination are the
    # same, so exit early with a success code.
    if [[ "$1" == "$2" ]]; then
        return 0
    fi

    mv "$1" "$2"
    echo "$1 -> $2"
}

if [[ -f "$1" ]]; then
    src_filename="${1%.*}"
    src_file_ext="${1##*.}"
    dst_filename=$(convert_to_kebab_case "$src_filename")".$src_file_ext"

    try_move "$1" "$dst_filename"
elif [[ -d "$1" ]]; then
    dst_dirname=$(convert_to_kebab_case "$1")

    try_move "$1" "$dst_dirname"
else
    echo "File or directory \`$1\` does not exist." 1>&2
    exit 1
fi
