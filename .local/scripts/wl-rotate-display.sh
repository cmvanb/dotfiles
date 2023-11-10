#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Rotate a wayland display 90 degrees.
#-------------------------------------------------------------------------------

set -o nounset
set -o pipefail

declare output="$1"

declare transform
transform="$("$XDG_SCRIPTS_HOME"/wl-get-output-transform.sh "$output")"

declare new_transform
if [ "$transform" = "normal" ]; then
    new_transform="90"
elif [ "$transform" = 90 ]; then
    new_transform="180"
elif [ "$transform" = 180 ]; then
    new_transform="270"
else
    new_transform="normal"
fi

wlr-randr --output "$output" --transform "$new_transform"
