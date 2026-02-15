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
source "$base_dir/modules/lib-shell-utils/src/fs.sh"
source "$base_dir/modules/lib-shell-utils/src/linux.sh"

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
source "$base_dir/modules/lib-shell-utils/deploy.sh"
source "$base_dir/modules/lib-theme/deploy.sh"

# Load theme modules
source "$base_dir/modules/theme-base/deploy.sh"

# Load server deployment modules
source "$base_dir/modules/bash/deploy.sh"
source "$base_dir/modules/bat/deploy.sh"
source "$base_dir/modules/fish/deploy.sh"
source "$base_dir/modules/git/deploy.sh"
source "$base_dir/modules/less/deploy.sh"
source "$base_dir/modules/lf/deploy.sh"
source "$base_dir/modules/npm/deploy.sh"
source "$base_dir/modules/nvim/deploy.sh"
source "$base_dir/modules/python/deploy.sh"
source "$base_dir/modules/readline/deploy.sh"
source "$base_dir/modules/ripgrep/deploy.sh"
source "$base_dir/modules/scripts-shell-utils/deploy.sh"
source "$base_dir/modules/wget/deploy.sh"
source "$base_dir/modules/yazi/deploy.sh"

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
