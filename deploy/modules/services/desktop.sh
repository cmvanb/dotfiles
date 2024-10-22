#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy desktop user services
#-------------------------------------------------------------------------------

echo "Deploying desktop user services..."

# Setup
#-------------------------------------------------------------------------------

source "$base_dir/.local/opt/shell-utils/linux.sh"

# Enable user services
#-------------------------------------------------------------------------------

declare distro_id
distro_id=$(get_distro_id)

if [[ $distro_id == "arch" ]]; then
    echo "└> Enabling Arch Linux user services."
    systemctl --user enable bluetooth-autoconnect
    systemctl --user enable ssh-agent
    systemctl --user enable udiskie
    systemctl --user enable pipewire
    systemctl --user enable syncthing

elif [[ $distro_id == "nixos" ]]; then
    : # Nothing currently.

elif [[ $distro_id == "debian" ]]; then
    : # Nothing currently.

elif [[ $distro_id == "ubuntu" ]]; then
    : # Nothing currently.

else
    echo "[$(basename "$0")] ERROR: Unknown distribution \`$distro_id\`, unable to deploy."
    exit 1
fi
