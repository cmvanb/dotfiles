#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Apply distro-specific configuration templates and links
#-------------------------------------------------------------------------------

set -euo pipefail

bash_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
source_dir=$(realpath "$bash_dir/..")

# Imports
#-------------------------------------------------------------------------------

source "$source_dir/.local/opt/shell-utils/fs.sh"
source "$source_dir/.local/opt/shell-utils/linux.sh"

# Host-specific configuration
#-------------------------------------------------------------------------------

config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

# Determine binary path
#-------------------------------------------------------------------------------

declare distro_id
distro_id=$(get_distro_id)

if [[ $distro_id == "arch" ]]; then
    echo "Applying Arch Linux configuration to \`$HOME\`."

    export SYSTEM_BINARY_PATH=/usr/bin

    force_link "$source_dir/.config/fish/interactive-arch.fish" "$config_dir/fish/interactive-distro.fish"
    force_link "$source_dir/.config/bash/interactive-arch.sh" "$config_dir/bash/interactive-distro.sh"

elif [[ $distro_id == "nixos" ]]; then
    echo "Applying NixOS configuration to \`$HOME\`."

    export SYSTEM_BINARY_PATH=/run/current-system/sw/bin

    force_link "$source_dir/.config/fish/interactive-nixos.fish" "$config_dir/fish/interactive-distro.fish"
    force_link "$source_dir/.config/bash/interactive-nixos.sh" "$config_dir/bash/interactive-distro.sh"

else
    echo "[$(basename "$0")] ERROR: Unknown distribution \`$distro_id\`, unable to deploy."
    exit 1
fi
