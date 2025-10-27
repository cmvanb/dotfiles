#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Refresh the usual suspects.
#-------------------------------------------------------------------------------

# Way-displays
#--------------------------------------------------------------------------------

pkill -x way-displays
way-displays > "/tmp/way-displays.${XDG_VTNR}.${USER}.log" 2>&1 &

# NOTE: Way-displays needs a moment.
sleep 0.25

# Autotiling
#--------------------------------------------------------------------------------

pkill -x autotiling

swaymsg "exec autotiling --outputs DP-3"
swaymsg "exec autotiling --outputs HDMI-A-6 DP-4 --splitratio 0.2"

# Reload Sway configuration
#--------------------------------------------------------------------------------

swaymsg reload
