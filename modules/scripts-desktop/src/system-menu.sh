#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# System menu: lock, log out, suspend, reboot, or shut down via the launcher.
# "Reboot to Windows" is offered only when systemd-boot lists the Windows entry deployed by manifesto.
#-------------------------------------------------------------------------------

if [[ "${TRACE-0}" == "1" ]]; then set -o xtrace; fi

options="Lock\nLogout\nSuspend\nReboot"
if windows-entry; then
    options+="\nReboot to Windows"
fi
options+="\nShutdown"

choice=$(echo -e "$options" | spawn-launcher.sh --menu --prompt "System")

case "$choice" in
    "Lock")               hyprlock ;;
    "Logout")             loginctl kill-session "$XDG_SESSION_ID" ;;
    "Suspend")            systemctl suspend ;;
    "Reboot")             systemctl reboot ;;
    "Reboot to Windows")  windows ;;
    "Shutdown")           systemctl poweroff ;;
esac
