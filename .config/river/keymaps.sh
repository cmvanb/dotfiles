#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# River key mappings
#
# See all valid mappings here: `/usr/include/xkbcommon/xkbcommon-keysyms.h`
#-------------------------------------------------------------------------------

declare config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
declare scripts_dir=${XDG_SCRIPTS_HOME:-$HOME/.local/scripts}
declare opt_dir=${XDG_OPT_HOME:-$HOME/.local/opt}

# Imports
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$opt_dir/shell-utils/debug.sh"

# Validation
#-------------------------------------------------------------------------------

assert_dependency alacritty
assert_dependency makoctl
assert_dependency qutebrowser
assert_dependency riverctl
assert_dependency river-shifttags
assert_dependency wofi

# System mappings
#-------------------------------------------------------------------------------

# Lock river
riverctl map normal Alt+Shift Z spawn "$scripts_dir/lock-screen.sh"

# Exit river
riverctl map normal Alt+Shift Q exit

# Shortcut mappings
#-------------------------------------------------------------------------------

# Run menu
riverctl map normal Alt O spawn "wofi --show drun"

# New terminal
riverctl map normal Alt T spawn "alacritty"

# New floating terminal
riverctl map normal Alt G spawn "alacritty --class floating"

# New terminal in a directory
riverctl map normal Alt+Shift T spawn "$scripts_dir/open-terminal-cwd.sh"

# Browser
riverctl map normal Alt B spawn "qutebrowser"

# Browser session
riverctl map normal Alt+Shift B spawn "$scripts_dir/open-qutebrowser-session.sh"

# Process manager
riverctl map normal Alt M spawn "alacritty --command btop"

# View mappings
#-------------------------------------------------------------------------------

# Toggle view float
riverctl map normal Alt Space toggle-float

# Toggle view fullscreen
riverctl map normal Alt F toggle-fullscreen

# Close view
riverctl map normal Alt Q close

# Bump the focused view to the top of the layout stack
riverctl map normal Alt Z zoom

# Focus the next/previous view in the layout stack
riverctl map normal Alt J focus-view next
riverctl map normal Alt K focus-view previous

# Swap the focused view with the next/previous view in the layout stack
riverctl map normal Alt+Shift J swap next
riverctl map normal Alt+Shift K swap previous

# Focus the left/right output
riverctl map normal Alt H focus-output left
riverctl map normal Alt L focus-output right

# Send the focused view to the left/right output
riverctl map normal Alt+Shift H spawn "$config_dir/river/send-and-focus-output.sh left"
riverctl map normal Alt+Shift L spawn "$config_dir/river/send-and-focus-output.sh right"

# Send the focused view to a specific output
riverctl map normal Alt X spawn "$config_dir/river/send-to-output.sh"

# Move views with mouse
riverctl map-pointer normal Shift BTN_LEFT move-view

# Resize views with mouse
riverctl map-pointer normal Shift BTN_RIGHT resize-view

# Tag mappings
#-------------------------------------------------------------------------------

# Cycle focused tags
# see: https://gitlab.com/akumar-xyz/river-shifttags/-/tree/master
riverctl map normal Alt Tab spawn "river-shifttags"
riverctl map normal Alt Backspace spawn "river-shifttags --shift -1"

for i in $(seq 1 9); do
    # NOTE: Unconventional formatting here is to avoid a bug in tree-sitter-bash when parsing `<<`.
    # see: https://github.com/tree-sitter/tree-sitter-bash
    declare tags=$(( 1 << (i - 1) ))

    # Focus tag
    riverctl map normal Alt "$i" set-focused-tags $tags

    # Tag focused view
    # riverctl map normal Alt+Shift "$i" set-view-tags $tags
    riverctl map normal Alt+Shift "$i" spawn "$config_dir/river/send-view-to-tag.sh $tags"

    # Toggle focus of tag
    riverctl map normal Alt+Control "$i" toggle-focused-tags $tags
done

# Layout mappings
#-------------------------------------------------------------------------------

# Change layout orientation
riverctl map normal Alt Right send-layout-cmd rivercarro "main-location right"
riverctl map normal Alt Down send-layout-cmd rivercarro "main-location bottom"
riverctl map normal Alt Left send-layout-cmd rivercarro "main-location left"
riverctl map normal Alt Up send-layout-cmd rivercarro "main-location top"

# Adjust layout main ratio
riverctl map normal Alt Page_Down send-layout-cmd rivercarro "main-ratio +0.05"
riverctl map normal Alt Page_Up send-layout-cmd rivercarro "main-ratio -0.05"

# Miscellaneous mappings
#-------------------------------------------------------------------------------

# Take screenshot of a selected rectangle
riverctl map normal Alt P spawn "$scripts_dir/screenshot-rectangle.sh"
riverctl map normal Alt+Shift P spawn "$scripts_dir/screenshot-rectangle.sh --upload"

# Dismiss notifications
riverctl map normal Alt D spawn "makoctl dismiss -a"
