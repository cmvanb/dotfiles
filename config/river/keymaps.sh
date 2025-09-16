#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# River key mappings
#
# See all valid mappings here: `/usr/include/xkbcommon/xkbcommon-keysyms.h`
#-------------------------------------------------------------------------------

declare config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
declare opt_dir=${XDG_OPT_HOME:-$HOME/.local/opt}

# Imports
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$opt_dir/shell-utils/debug.sh"

# Validation
#-------------------------------------------------------------------------------

assert_dependency makoctl
assert_dependency qutebrowser
assert_dependency riverctl
assert_dependency river-shifttags
assert_dependency spawn-terminal.sh

# System mappings
#-------------------------------------------------------------------------------

# Lock river
riverctl map normal Super+Shift Z spawn "hyprlock"

# Exit river
riverctl map normal Super+Shift W exit

# Shortcut mappings
#-------------------------------------------------------------------------------

# Run menu
riverctl map normal Super O spawn "$LAUNCHER"

# New terminal
riverctl map normal Super T spawn "spawn-terminal.sh"

# New floating terminal
riverctl map normal Super G spawn "spawn-terminal.sh --floating"

# New terminal in a directory
riverctl map normal Super+Shift T spawn "open-terminal-cwd.sh"

# Browser
riverctl map normal Super B spawn "qutebrowser"

# Browser session
riverctl map normal Super+Shift B spawn "open-qutebrowser-session.sh"

# Process manager
riverctl map normal Super M spawn "spawn-terminal.sh --command btop"

# Toggle waybar
riverctl map normal Super R spawn "toggle-waybar.sh"

# Dismiss all notifications
riverctl map normal Super Y spawn "makoctl dismiss -a"

# Take screenshot of a selected rectangle
riverctl map normal Super P spawn "screenshot-rectangle.sh"
riverctl map normal Super+Shift P spawn "screenshot-rectangle.sh --upload"

# View mappings
#-------------------------------------------------------------------------------

# Toggle view float
riverctl map normal Super Space toggle-float

# Toggle view fullscreen
riverctl map normal Super F toggle-fullscreen

# Close view
riverctl map normal Super W close

# Focus the next/previous view in the layout stack
riverctl map normal Super J focus-view next
riverctl map normal Super K focus-view previous

# Focus the left/right output
riverctl map normal Super H focus-output left
riverctl map normal Super L focus-output right

# Move the focused view to the top of the layout stack
riverctl map normal Super semicolon zoom

# Swap the focused view with the next/previous view in the layout stack
riverctl map normal Super+Control J swap next
riverctl map normal Super+Control K swap previous

# Send the focused view to the left/right output
riverctl map normal Super+Control H spawn "$config_dir/river/send-and-focus-output.sh left"
riverctl map normal Super+Control L spawn "$config_dir/river/send-and-focus-output.sh right"

# Send the focused view to a specific output
riverctl map normal Super+Control semicolon spawn "$config_dir/river/send-to-output.sh"

# Move views with mouse
riverctl map-pointer normal Super BTN_LEFT move-view

# Resize views with mouse
riverctl map-pointer normal Super BTN_RIGHT resize-view

# Close view with middle mouse button
riverctl map-pointer normal Super BTN_MIDDLE close

# Resize (floating) view
riverctl map normal Super+Shift D resize vertical -100
riverctl map normal Super+Shift F resize vertical 100
riverctl map normal Super+Shift G resize horizontal 200
riverctl map normal Super+Shift S resize horizontal -200

# Move (floating) view
riverctl map normal Super+Control D move up 100
riverctl map normal Super+Control F move down 100
riverctl map normal Super+Control G move right 200
riverctl map normal Super+Control S move left 200

# Tag mappings
#-------------------------------------------------------------------------------

# Cycle focused tags
# see: https://gitlab.com/akumar-xyz/river-shifttags/-/tree/master
riverctl map normal Super+Shift H spawn "river-shifttags --num-tags 20 --shift -1"
riverctl map normal Super+Shift L spawn "river-shifttags --num-tags 20"

# TODO: Move focused view to next/previous tag.

# Assign tags numerically
for i in $(seq 1 9); do
    # NOTE: There is a bug in tree-sitter-bash when parsing `<<`.
    # see: https://github.com/tree-sitter/tree-sitter-bash
    declare tags=$(( 1 << (i - 1) ))

    # Focus tag
    riverctl map normal Super "$i" set-focused-tags $tags

    # Send view to tag
    # riverctl map normal Super+Shift "$i" set-view-tags $tags
    riverctl map normal Super+Control "$i" spawn "$config_dir/river/send-view-to-tag.sh $tags"

    # Toggle focus of tag
    riverctl map normal Super+Shift "$i" toggle-focused-tags $tags
done

# Layout mappings
#-------------------------------------------------------------------------------

# Change layout orientation
riverctl map normal Super Right send-layout-cmd rivercarro "main-location right"
riverctl map normal Super Down send-layout-cmd rivercarro "main-location bottom"
riverctl map normal Super Left send-layout-cmd rivercarro "main-location left"
riverctl map normal Super Up send-layout-cmd rivercarro "main-location top"

# Adjust layout main ratio
riverctl map normal Super+Shift equal send-layout-cmd rivercarro "main-ratio +0.05"
riverctl map normal Super minus send-layout-cmd rivercarro "main-ratio -0.05"
