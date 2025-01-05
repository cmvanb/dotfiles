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

# Shell library modules
source "$base_dir/deploy/modules/lib-shell-utils.sh"
source "$base_dir/deploy/modules/lib-theme.sh"

# Server deployment modules
source "$base_dir/deploy/modules/bash.sh"
source "$base_dir/deploy/modules/bat.sh"
source "$base_dir/deploy/modules/broot.sh"
source "$base_dir/deploy/modules/fish.sh"
source "$base_dir/deploy/modules/git.sh"
source "$base_dir/deploy/modules/less.sh"
source "$base_dir/deploy/modules/lf.sh"
source "$base_dir/deploy/modules/npm.sh"
source "$base_dir/deploy/modules/nvim.sh"
source "$base_dir/deploy/modules/python.sh"
source "$base_dir/deploy/modules/readline.sh"
source "$base_dir/deploy/modules/ripgrep.sh"
source "$base_dir/deploy/modules/scripts-shell-utils.sh"
source "$base_dir/deploy/modules/shell-stty.sh"
source "$base_dir/deploy/modules/wget.sh"

# Deploy server profile
#-------------------------------------------------------------------------------

echo "Deploying server profile from \`$base_dir\` to \`$HOME\`..."

# Shell libraries
lib-shell-utils::install
lib-theme::install

# Theme configuration
source "$base_dir/deploy/modules/theme/base.sh"

# Configuration files
echo "Deploying server modules..."
bash::install
bat::install
broot::install
fish::install
git::install
less::install
lf::install
npm::install
nvim::install
python::install
readline::install
ripgrep::install
scripts-shell-utils::install
shell-stty::install
wget::install

echo "...deployment complete."
