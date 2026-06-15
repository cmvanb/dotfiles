#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Open Claude Code in a floating terminal, choosing a working directory from
# zoxide frecency history.
#-------------------------------------------------------------------------------

set -euo pipefail

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

debug::assert_dependency spawn-launcher.sh
debug::assert_dependency spawn-terminal.sh
debug::assert_dependency zoxide

declare target
target=$(printf "%s\n" "$(zoxide query --list)" | spawn-launcher.sh --menu --prompt="Open Claude Code at..." 2> /dev/null)

spawn-terminal.sh --floating --working-directory "$target" --command claude
