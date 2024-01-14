#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# River environment
#-------------------------------------------------------------------------------

declare opt_dir=${XDG_OPT_HOME:-$HOME/.local/opt}

# Tells libseat what login daemon we're using so it doesn't have to cry about it.
# TODO: This should be part of the river/systemd integration.
#-------------------------------------------------------------------------------

export LIBSEAT_BACKEND=logind

# QT performance flag.
# TODO: This should be part of the wayland/QT integration.
#-------------------------------------------------------------------------------

export QT_QPA_PLATFORM=wayland
export QT_SCALE_FACTOR_ROUNDING_POLICY=round

# XDG desktop portal integration.
#-------------------------------------------------------------------------------

export XDG_CURRENT_DESKTOP=river

# Cursor theme.
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$opt_dir/theme/theme.sh"

export XCURSOR_THEME=$cursor_theme

export XCURSOR_SIZE=$cursor_size
