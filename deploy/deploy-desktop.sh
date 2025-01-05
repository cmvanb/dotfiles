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

# Desktop deployment modules
source "$base_dir/deploy/modules/alacritty.sh"
source "$base_dir/deploy/modules/bitwarden.sh"
source "$base_dir/deploy/modules/bluetooth-autoconnect.sh"
source "$base_dir/deploy/modules/btop.sh"
source "$base_dir/deploy/modules/chromium.sh"
source "$base_dir/deploy/modules/direnv.sh"
source "$base_dir/deploy/modules/disable-xdg-desktop-files.sh"
source "$base_dir/deploy/modules/discord.sh"
source "$base_dir/deploy/modules/draw.io.sh"
source "$base_dir/deploy/modules/fontconfig.sh"
source "$base_dir/deploy/modules/ghostty.sh"
source "$base_dir/deploy/modules/hyprland.sh"
source "$base_dir/deploy/modules/imv.sh"
source "$base_dir/deploy/modules/mako.sh"
source "$base_dir/deploy/modules/mpv.sh"
source "$base_dir/deploy/modules/niri.sh"
source "$base_dir/deploy/modules/pandoc.sh"
source "$base_dir/deploy/modules/pipewire.sh"
source "$base_dir/deploy/modules/pyenv.sh"
source "$base_dir/deploy/modules/qutebrowser.sh"
source "$base_dir/deploy/modules/river.sh"
source "$base_dir/deploy/modules/scripts-desktop.sh"
source "$base_dir/deploy/modules/scripts-markdown.sh"
source "$base_dir/deploy/modules/scripts-misc.sh"
source "$base_dir/deploy/modules/ssh.sh"
source "$base_dir/deploy/modules/syncthing.sh"
source "$base_dir/deploy/modules/spotify.sh"
source "$base_dir/deploy/modules/udiskie.sh"
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
source "$base_dir/deploy/modules/scripts/desktop.sh"

# Server modules
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

# Desktop environment modules
echo "Deploying desktop modules..."
alacritty::install
bitwarden::install
bluetooth-autoconnect::install
btop::install
chromium::install
direnv::install
disable-xdg-desktop-files::install
discord::install
draw.io::install
fontconfig::install
ghostty::install
hyprland::install
imv::install
mako::install
mpv::install
niri::install
pandoc::install
pyenv::install
qutebrowser::install
river::install
scripts-desktop::install
scripts-markdown::install
scripts-misc::install
spotify::install
udiskie::install
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

# Enable user services
echo "Deploying desktop user services..."
bluetooth-autoconnect::enable
pipewire::enable
ssh::enable
syncthing::enable
udiskie::enable

echo "...deployment complete."
