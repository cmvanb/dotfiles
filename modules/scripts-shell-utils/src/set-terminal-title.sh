#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Set the terminal title
#-------------------------------------------------------------------------------

set -euo pipefail

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

if [[ -z "$1" ]]; then
    debug::error "Missing argument: string"
    exit 1
fi

printf "\033]0; %s\007" "$1" > /dev/tty
