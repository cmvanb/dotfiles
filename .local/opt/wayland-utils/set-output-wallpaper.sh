#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Set the wallpaper for a specified wayland output
#-------------------------------------------------------------------------------

# Imports
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"
source "$XDG_OPT_HOME/wayland-utils/output.sh"

# Validation
#-------------------------------------------------------------------------------

assert_dependency swaybg

# Functions
#-------------------------------------------------------------------------------

set_output_wallpaper () {
    if wl_output_exists "$1"; then
        swaybg --output "$1" --mode fill --image "$2" > /dev/null 2>&1 &
    fi
}
