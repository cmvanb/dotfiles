#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Rotate a wayland display 90 degrees.
#-------------------------------------------------------------------------------

set -o nounset
set -o pipefail

OUTPUT="$1"

TRANSFORM="$($XDG_SCRIPTS_HOME/wl-get-output-transform.sh $OUTPUT)"

if [ $TRANSFORM = "normal" ]; then
    NEW_TRANSFORM="90"
elif [ $TRANSFORM = 90 ]; then
    NEW_TRANSFORM="180"
elif [ $TRANSFORM = 180 ]; then
    NEW_TRANSFORM="270"
else
    NEW_TRANSFORM="normal"
fi

wlr-randr --output $OUTPUT --transform $NEW_TRANSFORM

