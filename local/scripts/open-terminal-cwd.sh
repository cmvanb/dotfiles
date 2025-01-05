#-------------------------------------------------------------------------------
# Open a new terminal and change the working directory, choosing from zoxide
# history.
#-------------------------------------------------------------------------------

set -euo pipefail

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

# TODO: Generalize to run any command.
if [[ $XDG_CURRENT_DESKTOP == "Hyprland" ]]; then
    assert_dependency hyprctl

    hyprctl dispatch exec "alacritty --working-directory $target"
    exit 0

elif [[ $XDG_CURRENT_DESKTOP == "niri" ]]; then
    assert_dependency niri

    niri msg action spawn -- "sh" "-c" "alacritty --working-directory $target"
    exit 0

elif [[ $XDG_CURRENT_DESKTOP == "river" ]]; then
    assert_dependency riverctl

    riverctl spawn "alacritty --working-directory $target"
    exit 0

else
    echo "[$(basename "$0")] ERROR: Unsupported desktop environment: $XDG_CURRENT_DESKTOP" >&2
    exit 1
fi
