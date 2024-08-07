#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Preview a file
#-------------------------------------------------------------------------------

set -uo pipefail

# Imports
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"
# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/fs.sh"

# Validation
#-------------------------------------------------------------------------------

assert_dependency chafa
assert_dependency mediainfo
assert_dependency gs
assert_dependency zipinfo
assert_dependency tree
assert_dependency tar
assert_dependency 7z
assert_dependency bat

if [[ -z "$1" ]]; then
    echo "[$(basename "$0")] ERROR: Missing argument: file name"
    exit 1
fi

if [[ ! -r "$1" ]]; then
    echo "[$(basename "$0")] ERROR: File is not readable."
    exit 1
fi

# Choose a file preview method based on file mime type and extension.
#-------------------------------------------------------------------------------

mimetype=$(file_mime_type "$1")
encoding=$(file_encoding "$1")
extension=$(file_extension "$1")

lines=$(stty -F /dev/tty size | cut -d' ' -f1)
max_lines=$(( lines - 2 ))

if [[ $mimetype == "image"* ]]; then
    chafa -f sixel -s "$2x$3" --polite on "$1"

elif [[ $mimetype == "video"* || $mimetype == "audio"* ]]; then
    mediainfo "$1"

elif [[ $mimetype == *"pdf" ]]; then
    gs -q -dNOPAUSE -dBATCH -sDEVICE=jpeg -r240 -sOutputFile=- -dLastPage=1 "$1" \
        | chafa -f sixel -s "$2x$3" --polite on

elif [[ $mimetype == "application/zip" ]]; then
    zipinfo -1 "$1" | tree --fromfile . | head -n -2

elif [[ $mimetype == *"gzip" ]]; then
    tar -ztvf "$1" | awk '{print $6}' | tree --fromfile . | head -n -2

elif [[ $mimetype == *"x-tar" && $extension == *".tar.bz2" ]]; then
    tar -jtvf "$1" | awk '{print $6}' | tree --fromfile . | head -n -2

elif [[ $mimetype == *"x-tar" || $mimetype == *"x-xz" ]]; then
    tar -tvf "$1" | awk '{print $6}' | tree --fromfile . | head -n -2

elif [[ $mimetype == *"7z"* ]]; then
    7z l -ba "$1" | awk '{print $NF}' | tree --fromfile . | head -n -2

elif [[ $mimetype == "application/json" ]] || [[ $mimetype == "text/plain" && $extension == "json" ]]; then
    declare parsed
    if parsed=$(jq --indent 4 --color-output . "$1"); then
        echo "$parsed" | bat --style=numbers --force-colorization --paging=never --wrap=never --line-range=":$max_lines"
    else
        bat --style=numbers --force-colorization --paging=never --wrap=never --line-range=":$max_lines" "$1"
    fi

elif [[ $mimetype == "text"* || $encoding == *"ascii" || $encoding == "utf-8" ]]; then
    bat --style=numbers --force-colorization --paging=never --wrap=never --line-range=":$max_lines" "$1"

elif file_is_binary "$1"; then
    file -b --mime "$1" && echo "" && hexdump "$1"

else
    file -b --mime "$1" && echo "[$(basename "$0")] ERROR: unknown file type"

fi
