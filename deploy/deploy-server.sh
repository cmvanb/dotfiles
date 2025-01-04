#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy the server profile
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
export SYSTEM_PROFILE="server"
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

echo "Deploying server profile from \`$base_dir\` to \`$HOME\`..."

# Shell libraries
source "$base_dir/deploy/modules/opt/base.sh"

# Theme configuration
source "$base_dir/deploy/modules/theme/base.sh"

# Binary shortcuts
source "$base_dir/deploy/modules/bin/base.sh"

# Shell scripts
source "$base_dir/deploy/modules/scripts/base.sh"

# Configuration files
source "$base_dir/deploy/modules/config/base.sh"

echo "...deployment complete."
