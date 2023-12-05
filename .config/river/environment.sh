#!/usr/bin/env bash

# TODO: This should be part of the river/systemd integration.
# Tells libseat what login daemon we're using so it doesn't have to cry about it.
export LIBSEAT_BACKEND=logind

# TODO: This should be part of the wayland/QT integration.
# QT performance flag.
export QT_QPA_PLATFORM=wayland

# XDG desktop portal integration.
export XDG_CURRENT_DESKTOP=river
