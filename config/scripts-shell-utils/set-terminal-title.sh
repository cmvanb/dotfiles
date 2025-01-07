#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Set the terminal title
#-------------------------------------------------------------------------------

set -euo pipefail

if [[ -z "$1" ]]; then
    echo "[$(basename "$0")] ERROR: Missing argument: string"
    exit 1
fi

printf "\033]0; %s\007" "$1" > /dev/tty
