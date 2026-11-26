#!/usr/bin/env bash
if compgen -G "/sys/class/power_supply/BAT*" > /dev/null; then
    systemctl suspend-then-hibernate
else
    systemctl suspend
fi
