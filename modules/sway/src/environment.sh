#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Sway environment
#-------------------------------------------------------------------------------

# Set cursor theme path.
export XCURSOR_PATH="/usr/share/icons"

# QT performance flag.
export QT_QPA_PLATFORM=wayland
export QT_SCALE_FACTOR_ROUNDING_POLICY=round

# Force GTK4/libadwaita apps to use the carbon GTK theme. `carbon-gtk` is an
# alias for the active variant, repointed by `theme switch`.
# libadwaita ignores the gsettings gtk-theme-name; GTK_THEME env var is required.
export GTK_THEME=carbon-gtk

# Qt apps read the carbon Qt theme through qt6ct, which follows `theme switch`.
export QT_QPA_PLATFORMTHEME=qt6ct

# XDG desktop portal integration.
export XDG_CURRENT_DESKTOP=sway
