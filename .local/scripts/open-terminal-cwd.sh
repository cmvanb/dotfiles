#-------------------------------------------------------------------------------
# Open a new terminal and change the working directory.
#-------------------------------------------------------------------------------

set -euo pipefail

# Imports
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

# Validation
#-------------------------------------------------------------------------------

assert_dependency riverctl
assert_dependency wofi

# Choose the working directory
#-------------------------------------------------------------------------------

declare -A directories=(
    ["dotfiles"]="$HOME/Code/dotfiles"
    ["Code"]="$HOME/Code"
    ["Documents"]="$HOME/Documents"
    ["Downloads"]="$HOME/Downloads"
    ["Media"]="$HOME/Media"
    ["Projects"]="$HOME/Projects"
    ["Wiki"]="$HOME/Wiki"
)

declare target
target=$(printf "%s\n" "${!directories[@]}" | wofi --dmenu 2> /dev/null)

# Spawn a new terminal
#-------------------------------------------------------------------------------

riverctl spawn "alacritty --command $SHELL -c 'cd ${directories[$target]} && $SHELL'"
