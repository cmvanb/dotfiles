#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Preview a file
#-------------------------------------------------------------------------------

set -euo pipefail

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

case "$1" in
    *.jpg|*.jpeg|*.png) chafa "$1" -f sixel -s "$(($2-2))x$3" | sed 's/#/\n#/g' ;;
    *.pdf) gs -q -dNOPAUSE -dBATCH -sDEVICE=jpeg -r240 -sOutputFile=- \
        -dLastPage=1 "$1" | chafa -f sixel -s "$(($2-2))x$3" | sed 's/#/\n#/g' ;;
    *) bat --force-colorization --paging=never --style=numbers --wrap never \
        -f "$1" ;;
esac
