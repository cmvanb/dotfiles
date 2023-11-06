#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy the dotfiles
#-------------------------------------------------------------------------------

set -euo pipefail

bash_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
echo $bash_dir
source_dir=$(realpath "$bash_dir/..")

# Imports
#-------------------------------------------------------------------------------

source "$source_dir/.local/scripts/linux-utils.sh"

# Determine binary path
#-------------------------------------------------------------------------------

distro_id=$(get_distro_id)

if [[ $distro_id == "arch" ]]; then
    export SYSTEM_BINARY_PATH=/usr/bin
elif [[ $distro_id == "nixos" ]]; then
    export SYSTEM_BINARY_PATH=/run/current-system/sw/bin
else
    echo "[$(basename "$0")] ERROR: Unknown distribution \`$distro_id\`, unable to deploy."
    exit 1
fi

# Necessary environment vars
#-------------------------------------------------------------------------------

export XDG_CONFIG_HOME="$HOME/.config"

# Deploy dotfiles
#-------------------------------------------------------------------------------

echo "Deploying dotfiles from \`$source_dir\` to \`$HOME\`..."

source "$bash_dir/link-dotfiles.sh"
source "$bash_dir/generate-dotfiles-templates.sh"
source "$bash_dir/apply-host-configuration.sh"
source "$bash_dir/configure-syncthing.sh"
source "$bash_dir/enable-systemd-services.sh"
source "$bash_dir/install-user-packages.sh"
source "$bash_dir/configure-theme.sh"

echo "...deployment complete."
