#-------------------------------------------------------------------------------
# Open a new terminal and change the working directory, choosing from zoxide
# history.
#-------------------------------------------------------------------------------

set -euo pipefail

declare scripts_dir=${XDG_SCRIPTS_HOME:-$HOME/.local/scripts}

# Imports
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

# Choose the working directory
#-------------------------------------------------------------------------------

assert_dependency wofi
assert_dependency zoxide

declare target
target=$(printf "%s\n" "$(zoxide query --list)" | wofi -p "Open terminal at..." --dmenu 2> /dev/null)

# Spawn a new terminal
#-------------------------------------------------------------------------------

"$scripts_dir/spawn-terminal.sh" --working-directory "$target"
