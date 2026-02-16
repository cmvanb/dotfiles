#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Open a new terminal and change the working directory, choosing from zoxide
# history.
#-------------------------------------------------------------------------------

set -euo pipefail

# Imports
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

assert_dependency spawn-launcher.sh
assert_dependency spawn-terminal.sh
assert_dependency zoxide

# Choose the working directory
#-------------------------------------------------------------------------------

declare target
target=$(printf "%s\n" "$(zoxide query --list)" | spawn-launcher.sh --menu --prompt="Open terminal at..." 2> /dev/null)

# Spawn a new terminal
#-------------------------------------------------------------------------------

spawn-terminal.sh --working-directory "$target" "$@"
