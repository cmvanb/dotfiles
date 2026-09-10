#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# System menu: lock, log out, suspend, reboot, reboot to Windows, or shut down
# via the launcher.
#-------------------------------------------------------------------------------

if [[ "${TRACE-0}" == "1" ]]; then set -o xtrace; fi

options="Lock\nLogout\nSuspend\nReboot\nReboot to Windows\nShutdown"

choice=$(echo -e "$options" | spawn-launcher.sh --menu --prompt "System")

case "$choice" in
    "Lock")               hyprlock ;;
    "Logout")             loginctl kill-session "$XDG_SESSION_ID" ;;
    "Suspend")            systemctl suspend ;;
    "Reboot")             systemctl reboot ;;
    "Reboot to Windows")  systemctl reboot --boot-loader-entry=02-windows.conf ;;
    "Shutdown")           systemctl poweroff ;;
esac
