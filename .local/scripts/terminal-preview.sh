#!/bin/sh
#-------------------------------------------------------------------------------
# Preview a file
#-------------------------------------------------------------------------------

set -o nounset
set -o pipefail

case "$1" in
    *.jpg|*.jpeg|*.png) chafa "$1" -f sixel -s "$(($2-2))x$3" | sed 's/#/\n#/g' ;;
    *) bat --force-colorization --paging=never --style=changes,numbers \
            --wrap never -f "$1" && false ;;
esac
