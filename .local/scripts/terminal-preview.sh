#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Preview a file
#-------------------------------------------------------------------------------

set -euo pipefail

# Imports
#-------------------------------------------------------------------------------

source $XDG_SCRIPTS_HOME/fs-utils.sh

# Validation
#-------------------------------------------------------------------------------

if ! command -v chafa &> /dev/null; then
    echo "["$(basename "$0")"] ERROR: Missing dependency: chafa"
    exit 1
fi

if ! command -v mediainfo &> /dev/null; then
    echo "["$(basename "$0")"] ERROR: Missing dependency: mediainfo"
    exit 1
fi

if ! command -v gs &> /dev/null; then
    echo "["$(basename "$0")"] ERROR: Missing dependency: gs"
    exit 1
fi

if ! command -v zipinfo &> /dev/null; then
    echo "["$(basename "$0")"] ERROR: Missing dependency: zipinfo"
    exit 1
fi

if ! command -v tree &> /dev/null; then
    echo "["$(basename "$0")"] ERROR: Missing dependency: tree"
    exit 1
fi

if ! command -v tar &> /dev/null; then
    echo "["$(basename "$0")"] ERROR: Missing dependency: tar"
    exit 1
fi

if ! command -v 7z &> /dev/null; then
    echo "["$(basename "$0")"] ERROR: Missing dependency: 7z"
    exit 1
fi

if ! command -v bat &> /dev/null; then
    echo "["$(basename "$0")"] ERROR: Missing dependency: bat"
    exit 1
fi

if [[ -z "$1" ]]; then
    echo "[$(basename "$0")] ERROR: Missing argument: file name"
    exit 1
fi

# Choose a file preview method based on file mime type and extension.
#-------------------------------------------------------------------------------

mimetype=$(file_mime_type "$1")
encoding=$(file_encoding "$1")
extension=$(file_extension "$1")

if [[ $mimetype == "image"* ]]; then
    chafa "$1" -f sixel -s "$(($2-2))x$3" | sed 's/#/\n#/g'

elif [[ $mimetype == "video"* || $mimetype == "audio"* ]]; then
    mediainfo "$1"

elif [[ $mimetype == *"pdf" ]]; then
    gs -q -dNOPAUSE -dBATCH -sDEVICE=jpeg -r240 -sOutputFile=- -dLastPage=1 "$1" \
        | chafa -f sixel -s "$(($2-2))x$3" | sed 's/#/\n#/g'

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

elif [[ $mimetype == "text"* || $encoding == *"ascii" || $encoding == "utf-8" ]]; then
    bat --force-colorization --paging=never --style=numbers --wrap never -f "$1"

elif file_is_binary "$1"; then
    file -b --mime "$1" && echo "" && hexdump "$1"

else
    file -b --mime "$1" && echo "[$(basename "$0")] ERROR: unknown file type"

fi
