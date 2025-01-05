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

# Deployment modules
source "$base_dir/deploy/modules/alacritty.sh"
source "$base_dir/deploy/modules/bitwarden.sh"
source "$base_dir/deploy/modules/btop.sh"
source "$base_dir/deploy/modules/chromium.sh"
source "$base_dir/deploy/modules/direnv.sh"
source "$base_dir/deploy/modules/disable-xdg-desktop-files.sh"
source "$base_dir/deploy/modules/discord.sh"
source "$base_dir/deploy/modules/draw.io.sh"
source "$base_dir/deploy/modules/fontconfig.sh"
source "$base_dir/deploy/modules/hyprland.sh"
source "$base_dir/deploy/modules/imv.sh"
source "$base_dir/deploy/modules/mako.sh"
source "$base_dir/deploy/modules/mpv.sh"
source "$base_dir/deploy/modules/niri.sh"
source "$base_dir/deploy/modules/pandoc.sh"
source "$base_dir/deploy/modules/python.sh"
source "$base_dir/deploy/modules/qutebrowser.sh"
source "$base_dir/deploy/modules/river.sh"
source "$base_dir/deploy/modules/spotify.sh"
source "$base_dir/deploy/modules/vscodium.sh"
source "$base_dir/deploy/modules/vt.sh"
source "$base_dir/deploy/modules/waybar.sh"
source "$base_dir/deploy/modules/wallpaper.sh"
source "$base_dir/deploy/modules/way-displays.sh"
source "$base_dir/deploy/modules/wezterm.sh"
source "$base_dir/deploy/modules/wofi.sh"
source "$base_dir/deploy/modules/xdg-mimetype-associations.sh"
source "$base_dir/deploy/modules/yay.sh"
source "$base_dir/deploy/modules/zathura.sh"

# Deploy desktop profile
#-------------------------------------------------------------------------------

echo "Deploying desktop profile from \`$base_dir\` to \`$HOME\`..."

# Shell modules
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

alacritty::install
bitwarden::install
btop::install
chromium::install
direnv::install
disable-xdg-desktop-files::install
discord::install
draw.io::install
fontconfig::install
hyprland::install
imv::install
mako::install
mpv::install
niri::install
pandoc::install
python::install
qutebrowser::install
river::install
spotify::install
vscodium::install
vt::install
waybar::install
wallpaper::install
way-displays::install
wezterm::install
wofi::install
xdg-mimetype-associations::install
yay::install
zathura::install
source "$base_dir/deploy/modules/config/desktop.sh"

# Enable user services
source "$base_dir/deploy/modules/services/desktop.sh"

# Install user packages
source "$base_dir/deploy/modules/packages/desktop.sh"

echo "...deployment complete."
