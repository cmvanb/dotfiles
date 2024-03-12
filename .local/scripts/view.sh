#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# View a text file in the pager.
#-------------------------------------------------------------------------------

set -euo pipefail

formatted=$("$XDG_SCRIPTS_HOME/format-text.sh" "$1")

echo "$formatted" | less -c -R --chop-long-lines
