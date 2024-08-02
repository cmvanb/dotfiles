#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Enable systemd user services
#-------------------------------------------------------------------------------

base_dir="$(realpath "$(dirname "$(realpath "$0")")/..")"

# Imports
#-------------------------------------------------------------------------------

source "$base_dir/.local/opt/shell-utils/linux.sh"

echo "Enabling systemd user services."

# Enable system services
#-------------------------------------------------------------------------------

declare distro_id
distro_id=$(get_distro_id)

if [[ $distro_id == "arch" ]]; then
    echo "Enabling Arch Linux services."

    systemctl --user enable mako
    systemctl --user enable ssh-agent
    systemctl --user enable udiskie
    systemctl --user enable pipewire
    systemctl --user enable syncthing

elif [[ $distro_id == "nixos" ]]; then
    echo "Enabling NixOS services."

    # Nothing currently.

elif [[ $distro_id == "debian" ]]; then
    echo "Enabling Debian services."

    # Nothing currently.

elif [[ $distro_id == "ubuntu" ]]; then
    echo "Enabling Ubuntu services."

    # Nothing currently.

else
    echo "[$(basename "$0")] ERROR: Unknown distribution \`$distro_id\`, unable to deploy."
    exit 1
fi
