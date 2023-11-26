#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy the dotfiles
#-------------------------------------------------------------------------------

set -euo pipefail

declare bash_dir
bash_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)

declare source_dir
source_dir=$(realpath "$bash_dir/..")

# Imports
#-------------------------------------------------------------------------------

source "$source_dir/.local/opt/shell-utils/linux.sh"

# Necessary environment vars
#-------------------------------------------------------------------------------

export XDG_CONFIG_HOME="$HOME/.config"

# Deploy dotfiles
#-------------------------------------------------------------------------------

echo "Deploying dotfiles from \`$source_dir\` to \`$HOME\`..."

# NOTE: Order matters.
source "$bash_dir/link-dotfiles.sh"
source "$bash_dir/apply-distro-configuration.sh"
source "$bash_dir/configure-theme.sh"
source "$bash_dir/generate-dotfiles-templates.sh"
source "$bash_dir/apply-host-configuration.sh"
source "$bash_dir/configure-syncthing.sh"
source "$bash_dir/enable-systemd-services.sh"
source "$bash_dir/install-user-packages.sh"

echo "...deployment complete."
