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

if ! command -v gs &> /dev/null; then
    echo "["$(basename "$0")"] ERROR: Missing dependency: gs"
    exit 1
fi

if ! command -v zipinfo &> /dev/null; then
    echo "["$(basename "$0")"] ERROR: Missing dependency: zipinfo"
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

# Choose a file preview method based on file name extension
#-------------------------------------------------------------------------------

handle_other () {
    mimetype=$(file_mime_type "$1")
    encoding=$(file_encoding "$1")

    if [[ $mimetype == "text"* || $encoding == *"ascii" ]]; then
        bat --force-colorization --paging=never --style=numbers --wrap never -f "$1"
    elif file_is_binary "$1"; then
        file -b --mime "$1" && hexdump "$1"
    else
        file -b --mime "$1"
    fi
}

case "$1" in
    *.jpg|*.jpeg|*.png) chafa "$1" -f sixel -s "$(($2-2))x$3" | sed 's/#/\n#/g'
        ;;
    *.mkv|*.mp4|*.m4v) mediainfo "$1"
        ;;
    *.pdf) gs -q -dNOPAUSE -dBATCH -sDEVICE=jpeg -r240 -sOutputFile=- \
        -dLastPage=1 "$1" | chafa -f sixel -s "$(($2-2))x$3" | sed 's/#/\n#/g'
        ;;
    *.zip) zipinfo "$1"
        ;;
    *.tar.gz) tar -ztvf "$1"
        ;;
    *.tar.bz2) tar -jtvf "$1"
        ;;
    *.tar) tar -tvf "$1"
        ;;
    *.7z) 7z l "$1"
        ;;
    *) handle_other "$1"
        ;;
esac
