#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy the server profile
#-------------------------------------------------------------------------------

# Bootstrapping
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
export DEPLOY_PROFILE="server"
export DEPLOY_DISTRO="$(get_distro_id)"

# Determine which shell the template engine executes
export ESH_SHELL=/usr/bin/bash

# Load shell library modules
source "$base_dir/deploy/modules/lib-shell-utils.sh"
source "$base_dir/deploy/modules/lib-theme.sh"

# Load theme modules
source "$base_dir/deploy/modules/theme-base.sh"

# Load server deployment modules
source "$base_dir/deploy/modules/bash.sh"
source "$base_dir/deploy/modules/bat.sh"
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
source "$base_dir/deploy/modules/wget.sh"
source "$base_dir/deploy/modules/yazi.sh"

# Deploy server profile
#-------------------------------------------------------------------------------

echo "Deploying server profile from \`$base_dir\` to \`$HOME\`..."

echo "Deploying library modules..."
lib-shell-utils::install
lib-theme::install

echo "Deploying theme modules..."
theme-base::install

echo "Deploying server modules..."
bash::install
bat::install
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
wget::install
yazi::install

echo "...deployment complete."
