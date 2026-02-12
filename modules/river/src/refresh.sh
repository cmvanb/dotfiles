#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Refresh the usual suspects.
#-------------------------------------------------------------------------------

systemd-cat --identifier=river echo "Refreshing River..."

# Way-displays
#--------------------------------------------------------------------------------

pkill -x way-displays
way-displays > "/tmp/way-displays.${XDG_VTNR}.${USER}.log" 2>&1 &

# NOTE: Way-displays needs a moment.
sleep 0.25

# Rivercarro
#--------------------------------------------------------------------------------

pkill -x rivercarro
riverctl spawn "rivercarro -inner-gaps 6 -outer-gaps 0 -main-ratio 0.65 -main-location right"
