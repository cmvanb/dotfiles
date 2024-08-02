#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Apply distro-specific configuration templates and links
#-------------------------------------------------------------------------------

base_dir="$(realpath "$(dirname "$(realpath "$0")")/..")"
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

# Imports
#-------------------------------------------------------------------------------

source "$base_dir/.local/opt/shell-utils/fs.sh"
source "$base_dir/.local/opt/shell-utils/linux.sh"

# Determine binary path
#-------------------------------------------------------------------------------

declare distro_id
distro_id=$(get_distro_id)

if [[ $distro_id == "arch" ]]; then
    echo "Applying Arch Linux configuration to \`$HOME\`."

    export SYSTEM_BINARY_PATH=/usr/bin
    export ESH_SHELL=$SYSTEM_BINARY_PATH/bash

    force_link "$base_dir/.config/fish/interactive-arch.fish" "$config_dir/fish/interactive-distro.fish"
    force_link "$base_dir/.config/bash/interactive-arch.sh" "$config_dir/bash/interactive-distro.sh"

elif [[ $distro_id == "nixos" ]]; then
    echo "Applying NixOS configuration to \`$HOME\`."

    export SYSTEM_BINARY_PATH=/run/current-system/sw/bin
    export ESH_SHELL=$SYSTEM_BINARY_PATH/bash

    force_link "$base_dir/.config/fish/interactive-nixos.fish" "$config_dir/fish/interactive-distro.fish"
    force_link "$base_dir/.config/bash/interactive-nixos.sh" "$config_dir/bash/interactive-distro.sh"

elif [[ $distro_id == "debian" ]] || [[ $distro_id == "ubuntu" ]]; then
    echo "Applying Debian/Ubuntu configuration to \`$HOME\`."

    export SYSTEM_BINARY_PATH=/usr/bin
    export ESH_SHELL=$SYSTEM_BINARY_PATH/bash

    force_link "$base_dir/.config/fish/interactive-debian.fish" "$config_dir/fish/interactive-distro.fish"
    force_link "$base_dir/.config/bash/interactive-debian.sh" "$config_dir/bash/interactive-distro.sh"

else
    echo "[$(basename "$0")] ERROR: Unknown distribution \`$distro_id\`, unable to deploy."
    exit 1
fi
