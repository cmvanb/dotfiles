#-------------------------------------------------------------------------------
# Open a new terminal and change the working directory, choosing from zoxide
# history.
#-------------------------------------------------------------------------------

set -euo pipefail

# Imports
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

# Validation
#-------------------------------------------------------------------------------

assert_dependency niri
assert_dependency wofi
assert_dependency zoxide

# Choose the working directory
#-------------------------------------------------------------------------------

declare target
target=$(printf "%s\n" "$(zoxide query --list)" | wofi -p "Open terminal at..." --dmenu 2> /dev/null)

# Spawn a new terminal
#-------------------------------------------------------------------------------

niri msg action spawn -- "sh" "-c" "wezterm start --cwd $target"
