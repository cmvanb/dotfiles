#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Preview a file
#-------------------------------------------------------------------------------

set -euo pipefail

if [[ -z "$1" ]]; then
    echo "[$(basename "$0")] ERROR: Missing argument: file name"
    exit 1
fi

case "$1" in
    *.jpg|*.jpeg|*.png) chafa "$1" -f sixel -s "$(($2-2))x$3" | sed 's/#/\n#/g' ;;
    *) bat --force-colorization --paging=never --style=numbers --wrap never \
        -f "$1" ;;
esac
