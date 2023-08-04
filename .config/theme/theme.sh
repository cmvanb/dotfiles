#!/bin/sh
#-------------------------------------------------------------------------------
# System theme Shell API
#
# All colors and fonts are defined as simple shell variables, therefore the 
# consumer should simply use these variables. This minimal API is purely for 
# convenience.
#-------------------------------------------------------------------------------

source $XDG_CONFIG_HOME/theme/colors
source $XDG_CONFIG_HOME/theme/fonts

color_named () {
    echo -n ${1:1}
}

# Usage: `$(color_hash $colorname)`
color_hash () {
    echo -n \#${1:1}
}

# Usage: `$(color_zerox $colorname)`
color_zerox () {
    echo -n 0x${1:1}
}

# Usage: `$(color_ansi $colorfg $colorbg)`
color_ansi () {
    $HOME/.scripts/color-hex-to-ansi.sh --fg=${1:1} --bg=${2:1}
}

# Usage: `$(color_ansi_fg $colorfg)`
color_ansi_fg () {
    $HOME/.scripts/color-hex-to-ansi.sh --fg=${1:1}
}

# Usage: `$(color_ansi_reset)`
color_ansi_reset () {
    $HOME/.scripts/color-hex-to-ansi.sh --reset
}

