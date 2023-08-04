#!/bin/sh

set -o nounset
set -o pipefail

# Tells libseat what login daemon we're using so it doesn't have to cry about it.
#export LIBSEAT_BACKEND=logind

# QT performance flag.
export QT_QPA_PLATFORM=wayland
