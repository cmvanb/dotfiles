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

color_named() {
    if [[ -z ${1+x} ]]; then
        return 1
    fi

    echo -n "${1:1}"
}

# Usage: `$(color_hash $colorname)`
color_hash() {
    if [[ -z ${1+x} ]]; then
        return 1
    fi

    echo -n "#${1:1}"
}

# Usage: `$(color_zerox $colorname)`
color_zerox() {
    if [[ -z ${1+x} ]]; then
        return 1
    fi

    echo -n "0x${1:1}"
}

color_rgb_int() {
    if [[ -z ${1+x} ]]; then
        return 1
    fi

    echo -n "$("$theme_lib_dir/color-hex-to-rgb-int.py" --color="$(color_named "$1")")"
}

# Usage: `$(color_css_rgba $colorname $alpha)`
color_css_rgba() {
    if [[ -z ${1+x} ]]; then
        return 1
    fi

    echo -n "$("$theme_lib_dir/color-hex-to-css-rgba.py" --color="$(color_named "$1")" --alpha="$2")"
}

# Usage: `$(color_ansi $colorfg $colorbg)`
color_ansi() {
    if [[ -z ${1+x} ]] || [[ -z ${2:x} ]]; then
        return 1
    fi

    "$theme_lib_dir/color-hex-to-ansi.sh" --fg="${1:1}" --bg="${2:1}"
}

# Usage: `$(color_ansi_fg $colorfg)`
color_ansi_fg() {
    if [[ -z ${1+x} ]]; then
        return 1
    fi

    "$theme_lib_dir/color-hex-to-ansi.sh" --fg="${1:1}"
}

# Usage: `$(color_ansi_reset)`
color_ansi_reset() {
    "$theme_lib_dir/color-hex-to-ansi.sh" --reset
}

color_256() {
    if [[ -z ${1+x} ]]; then
        return 1
    fi

    "$theme_lib_dir/color-lookup-256-index.sh" "$1"
}

# Import the system theme variables.
#-------------------------------------------------------------------------------

if [[ -r "$theme_config_dir/colors" ]]; then
    # shellcheck disable=SC1091
    source "$theme_config_dir/colors"
else
    echo "[$(basename "$0")] ERROR: Theme color file is not readable."
    exit 1
fi

if [[ -r "$theme_config_dir/fonts" ]]; then
    # shellcheck disable=SC1091
    source "$theme_config_dir/fonts"
fi

if [[ -r "$theme_config_dir/cursor" ]]; then
    # shellcheck disable=SC1091
    source "$theme_config_dir/cursor"
fi
