#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Toggle waybar on/off in Hyprland
#-------------------------------------------------------------------------------

if pgrep -x "waybar" > /dev/null; then
    pkill -x waybar

else
    nohup waybar &> /dev/null &

fi
