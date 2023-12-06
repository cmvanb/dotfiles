#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# System theme Shell API
#
# All colors and fonts are defined as simple shell variables, therefore the 
# consumer should simply use these variables. This minimal API is purely for 
# convenience.
#-------------------------------------------------------------------------------

declare theme_config_dir="$XDG_CONFIG_HOME/theme"
declare theme_lib_dir="$XDG_OPT_HOME/theme"

# API
#-------------------------------------------------------------------------------

color_named () {
    echo -n "${1:1}"
}

# Usage: `$(color_hash $colorname)`
color_hash () {
    echo -n "#${1:1}"
}

# Usage: `$(color_zerox $colorname)`
color_zerox () {
    echo -n "0x${1:1}"
}

# Usage: `$(color_ansi $colorfg $colorbg)`
color_ansi () {
    "$theme_lib_dir/color-hex-to-ansi.sh" --fg="${1:1}" --bg="${2:1}"
}

# Usage: `$(color_ansi_fg $colorfg)`
color_ansi_fg () {
    "$theme_lib_dir/color-hex-to-ansi.sh" --fg="${1:1}"
}

# Usage: `$(color_ansi_reset)`
color_ansi_reset () {
    "$theme_lib_dir/color-hex-to-ansi.sh" --reset
}

color_256 () {
    "$theme_lib_dir/color-lookup-256-index.sh" "$1"
}

# Import the system theme variables.
#-------------------------------------------------------------------------------

source "$theme_config_dir/colors"
source "$theme_config_dir/fonts"
