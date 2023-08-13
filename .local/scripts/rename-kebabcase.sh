#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Apply kebabcase formatting to a filename
#-------------------------------------------------------------------------------

set -o errexit
set -o nounset
set -o pipefail

. $XDG_SCRIPTS_HOME/name-formatting.sh

if [[ -f "$1" ]]; then
    SRC_FILENAME="${1%.*}"
    SRC_FILE_EXT="${1##*.}"
    DST_FILENAME=$(convert_to_kebab_case "$SRC_FILENAME")".$SRC_FILE_EXT"
    mv "$1" "$DST_FILENAME"
elif [[ -d "$1" ]]; then
    DST_DIRNAME=$(convert_to_kebab_case "$1")
    mv "$1" "$DST_DIRNAME"
else
    echo "File or directory `$1` does not exist." 1>&2; exit 1
fi

