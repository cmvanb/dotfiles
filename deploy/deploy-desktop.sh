#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy desktop profile
#-------------------------------------------------------------------------------

# Bootstrapping
#-------------------------------------------------------------------------------

# Script directory
script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/..")

# Utility functions
source "$base_dir/local/opt/shell-utils/fs.sh"
source "$base_dir/local/opt/shell-utils/linux.sh"

# Environment variables needed by deployment modules
export SYSTEM_PROFILE="desktop"
export SYSTEM_DISTRO="$(get_distro_id)"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.local/cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_OPT_HOME="$HOME/.local/opt"
export XDG_SCRIPTS_HOME="$HOME/.local/scripts"

# Determine which shell esh executes
export ESH_SHELL=/usr/bin/bash

# Deploy server profile
#-------------------------------------------------------------------------------

echo "Deploying desktop profile from \`$base_dir\` to \`$HOME\`..."

# Shell libraries
source "$base_dir/deploy/modules/opt/base.sh"
source "$base_dir/deploy/modules/opt/desktop.sh"

# Theme configuration
source "$base_dir/deploy/modules/theme/base.sh"
source "$base_dir/deploy/modules/theme/desktop.sh"

# Binary shortcuts
source "$base_dir/deploy/modules/bin/base.sh"
source "$base_dir/deploy/modules/bin/desktop.sh"

# Shell scripts
source "$base_dir/deploy/modules/scripts/base.sh"
source "$base_dir/deploy/modules/scripts/desktop.sh"

# Configuration files
source "$base_dir/deploy/modules/config/base.sh"
source "$base_dir/deploy/modules/config/desktop.sh"

# Enable user services
source "$base_dir/deploy/modules/services/desktop.sh"

# Install user packages
source "$base_dir/deploy/modules/packages/desktop.sh"

echo "...deployment complete."
