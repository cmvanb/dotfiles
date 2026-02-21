#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# System theme Shell API
#
# Colors are sourced from the generated cache as bare hex variables (no #).
# The functions below resolve a variable name to the desired format.
#-------------------------------------------------------------------------------

declare theme_lib_dir="$XDG_OPT_HOME/theme"

# API
#-------------------------------------------------------------------------------

# Usage: `$(color_named $colorname)`
# shellcheck disable=SC2329
color_named() {
    if [[ -z ${1+x} ]]; then
        return 1
    fi

    echo -n "$1"
}

# Usage: `$(color_hash $colorname)`
# shellcheck disable=SC2329
color_hash() {
    if [[ -z ${1+x} ]]; then
        return 1
    fi

    echo -n "#$1"
}

# Usage: `$(color_zerox $colorname)`
# shellcheck disable=SC2329
color_zerox() {
    if [[ -z ${1+x} ]]; then
        return 1
    fi

    echo -n "0x$1"
}

# Usage: `$(color_rgb_int $colorname)`
# shellcheck disable=SC2329
color_rgb_int() {
    if [[ -z ${1+x} ]]; then
        return 1
    fi

    python3 "$theme_lib_dir/theme.py" color_rgb_int_hex "$1"
}

# Usage: `$(color_css_rgba $colorname $alpha)`
# shellcheck disable=SC2329
color_css_rgba() {
    if [[ -z ${1+x} ]]; then
        return 1
    fi

    python3 "$theme_lib_dir/theme.py" color_css_rgba_hex "$1" "$2"
}

# Usage: `$(color_ansi $colorfg $colorbg)`
# shellcheck disable=SC2329
color_ansi() {
    if [[ -z ${1+x} ]] || [[ -z ${2+x} ]]; then
        return 1
    fi

    python3 "$theme_lib_dir/theme.py" color_ansi_hex "$1" "$2"
}

# Usage: `$(color_ansi_fg $colorfg)`
# shellcheck disable=SC2329
color_ansi_fg() {
    if [[ -z ${1+x} ]]; then
        return 1
    fi

    python3 "$theme_lib_dir/theme.py" color_ansi_fg_hex "$1"
}

# Usage: `$(color_ansi_reset)`
# shellcheck disable=SC2329
color_ansi_reset() {
    python3 "$theme_lib_dir/theme.py" color_ansi_reset
}

# Usage: `$(color_256 $colorname)`
# shellcheck disable=SC2329
color_256() {
    if [[ -z ${1+x} ]]; then
        return 1
    fi

    python3 "$theme_lib_dir/theme.py" color_256 "$1"
}

# Import the system theme variables.
#-------------------------------------------------------------------------------

declare theme_cache_dir="$XDG_CACHE_HOME/theme"

if [[ -r "$theme_cache_dir/theme-data.sh" ]]; then
    # shellcheck disable=SC1091
    source "$theme_cache_dir/theme-data.sh"
else
    echo "[$(basename "$0")] ERROR: Theme cache file is not readable. Run \`python3 \$XDG_OPT_HOME/theme/theme.py parse\` to generate it."
    exit 1
fi
