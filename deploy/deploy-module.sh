#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy an individual module
#-------------------------------------------------------------------------------

# Script directory
script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/..")

# Load utility modules
source "$base_dir/config/lib-shell-utils/fs.sh"
source "$base_dir/config/lib-shell-utils/linux.sh"

# Environment variables needed by deployment modules
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.local/cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_OPT_HOME="$HOME/.local/opt"
export XDG_SCRIPTS_HOME="$HOME/.local/scripts"

export DEPLOY_PROFILE="${DEPLOY_PROFILE:-desktop}"
export DEPLOY_DISTRO="$(get_distro_id)"

# Determine which shell the template engine executes
export ESH_SHELL=/usr/bin/bash

# Check if a module name was provided
if [ $# -eq 0 ]; then
    echo "Error: No module specified."
    echo "Usage: $0 <module_name>"
    exit 1
fi

module_name="$1"
module_path="$script_dir/modules/$module_name.sh"

# Verify the module exists
if [ ! -f "$module_path" ]; then
    echo "Error: Module '$module_name' not found at '$module_path'."
    exit 1
fi

echo "Deploying module: $module_name..."
source "$module_path"

# Check if the install function exists
if ! declare -F "${module_name}::install" > /dev/null; then
    echo "Error: Function '${module_name}::install' not found in module '$module_name'."
    exit 1
fi

if "${module_name}::install"; then
    echo "Module deployed."

else
    echo "Error: Failed to deploy module '$module_name'."
    exit 1
fi

