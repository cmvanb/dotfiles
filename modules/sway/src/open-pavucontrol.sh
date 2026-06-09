#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Open pavucontrol, or move it to the current workspace if already running.
#-------------------------------------------------------------------------------

set -euo pipefail

if pgrep -x pavucontrol > /dev/null; then
    swaymsg '[app_id="org.pulseaudio.pavucontrol"] move workspace current, focus'
else
    swaymsg exec pavucontrol
fi
