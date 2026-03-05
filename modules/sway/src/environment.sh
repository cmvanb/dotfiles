#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Sway environment
#-------------------------------------------------------------------------------

# Set cursor theme path.
export XCURSOR_PATH="/usr/share/icons"

# QT performance flag.
export QT_QPA_PLATFORM=wayland
export QT_SCALE_FACTOR_ROUNDING_POLICY=round

# Force GTK4/libadwaita apps to use the carbon-dark-gtk theme.
# libadwaita ignores the gsettings gtk-theme-name; GTK_THEME env var is required.
export GTK_THEME=carbon-dark-gtk

# XDG desktop portal integration.
export XDG_CURRENT_DESKTOP=sway
