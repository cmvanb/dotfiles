#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Toggle waybar on/off
#-------------------------------------------------------------------------------

if pgrep -x "waybar" > /dev/null; then
    pkill -x waybar

else
    nohup waybar &> /dev/null &

fi
