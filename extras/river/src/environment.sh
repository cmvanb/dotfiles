#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# River environment
#-------------------------------------------------------------------------------

# Tells libseat what login daemon we're using so it doesn't have to cry about it.
# TODO: This should be part of the river/systemd integration.
export LIBSEAT_BACKEND=logind

# QT performance flag.
# TODO: This should be part of the wayland/QT integration.
export QT_QPA_PLATFORM=wayland
export QT_SCALE_FACTOR_ROUNDING_POLICY=round

# Force GTK4/libadwaita apps to use the carbon GTK theme. `carbon-gtk` is an
# alias for the active variant, repointed by `theme switch`.
# libadwaita ignores the gsettings gtk-theme-name; GTK_THEME env var is required.
export GTK_THEME=carbon-gtk

# Qt apps read the carbon Qt theme through qt6ct, which follows `theme switch`.
export QT_QPA_PLATFORMTHEME=qt6ct

# XDG desktop portal integration.
export XDG_CURRENT_DESKTOP=river
