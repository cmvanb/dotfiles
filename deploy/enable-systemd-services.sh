#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Enable systemd user services
#-------------------------------------------------------------------------------

set -euo pipefail

echo "Enabling systemd user services."

# Enable system services
#-------------------------------------------------------------------------------

systemctl --user enable mako
systemctl --user enable ssh-agent
systemctl --user enable udiskie
systemctl --user enable pipewire
systemctl --user enable syncthing
