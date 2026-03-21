#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# System power menu: suspend, reboot, or shutdown via the launcher.
#-------------------------------------------------------------------------------

if [[ "${TRACE-0}" == "1" ]]; then set -o xtrace; fi

options="Suspend\nReboot\nShutdown"

choice=$(echo -e "$options" | spawn-launcher.sh --menu --prompt "Power")

case "$choice" in
    Suspend)  systemctl suspend ;;
    Reboot)   systemctl reboot ;;
    Shutdown) systemctl poweroff ;;
esac
