#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy the home configuration
#-------------------------------------------------------------------------------

base_dir="$(realpath "$(dirname "$(realpath "$0")")/..")"

# Imports
#-------------------------------------------------------------------------------

source "$base_dir/.local/opt/shell-utils/linux.sh"

# Required environment vars
#-------------------------------------------------------------------------------

# TODO: Are these necessary? Can they be bootstrapped another way?
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_OPT_HOME="$HOME/.local/opt"

# Deploy home configuration
#-------------------------------------------------------------------------------

echo "Deploying dotfiles from \`$base_dir\` to \`$HOME\`..."

# NOTE: Order matters.
source "$base_dir/deploy/link-dotfiles.sh"
source "$base_dir/deploy/apply-distro-configuration.sh"
source "$base_dir/deploy/configure-theme.sh"
source "$base_dir/deploy/generate-dotfiles-templates.sh"
source "$base_dir/deploy/apply-host-configuration.sh"
source "$base_dir/deploy/enable-systemd-services.sh"
source "$base_dir/deploy/install-user-packages.sh"

echo "...deployment complete."
