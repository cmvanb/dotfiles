#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy desktop profile
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
export XDG_TEMPLATES_DIR="$HOME/.local/share/templates"
export DEPLOY_PROFILE="desktop"
export DEPLOY_DISTRO="$(get_distro_id)"
export DEPLOY_WM="sway"

# Determine which shell the template engine executes
export ESH_SHELL=/usr/bin/bash

# Load shell library modules
source "$base_dir/modules/lib-shell-utils/deploy.sh"
source "$base_dir/modules/lib-theme/deploy.sh"
source "$base_dir/modules/lib-wayland-utils/deploy.sh"

# Load theme modules
source "$base_dir/modules/theme/deploy-base.sh"
source "$base_dir/modules/theme/deploy-desktop.sh"

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

# Load desktop deployment modules
source "$base_dir/modules/alacritty/deploy.sh"
source "$base_dir/modules/bitwarden/deploy.sh"
# source "$base_dir/modules/bluetooth-autoconnect/deploy.sh"
source "$base_dir/modules/chromium/deploy.sh"
source "$base_dir/modules/direnv/deploy.sh"
source "$base_dir/modules/disable-xdg-desktop-files/deploy.sh"
source "$base_dir/modules/discord/deploy.sh"
source "$base_dir/modules/draw.io/deploy.sh"
source "$base_dir/modules/firefox/deploy.sh"
source "$base_dir/modules/fontconfig/deploy.sh"
source "$base_dir/modules/fuzzel/deploy.sh"
source "$base_dir/modules/ghostty/deploy.sh"
source "$base_dir/modules/gitui/deploy.sh"
source "$base_dir/modules/hyprland/deploy.sh"
source "$base_dir/modules/hyprlock/deploy.sh"
source "$base_dir/modules/imv/deploy.sh"
source "$base_dir/modules/mako/deploy.sh"
source "$base_dir/modules/mpv/deploy.sh"
source "$base_dir/modules/pandoc/deploy.sh"
source "$base_dir/modules/pipewire/deploy.sh"
source "$base_dir/modules/pyenv/deploy.sh"
source "$base_dir/modules/qutebrowser/deploy.sh"
source "$base_dir/modules/river/deploy.sh"
source "$base_dir/modules/scripts-desktop/deploy.sh"
source "$base_dir/modules/scripts-markdown/deploy.sh"
source "$base_dir/modules/scripts-misc/deploy.sh"
source "$base_dir/modules/scripts-system-utils/deploy.sh"
source "$base_dir/modules/ssh/deploy.sh"
source "$base_dir/modules/sway/deploy.sh"
source "$base_dir/modules/syncthing/deploy.sh"
source "$base_dir/modules/spotify/deploy.sh"
source "$base_dir/modules/udiskie/deploy.sh"
source "$base_dir/modules/vscodium/deploy.sh"
source "$base_dir/modules/vt/deploy.sh"
source "$base_dir/modules/waybar/deploy.sh"
source "$base_dir/modules/way-displays/deploy.sh"
source "$base_dir/modules/wezterm/deploy.sh"
source "$base_dir/modules/wofi/deploy.sh"
source "$base_dir/modules/xdg-mimetype-associations/deploy.sh"
source "$base_dir/modules/yay/deploy.sh"
source "$base_dir/modules/zathura/deploy.sh"

# Deploy desktop profile
#-------------------------------------------------------------------------------

echo "Deploying desktop profile from \`$base_dir\` to \`$HOME\`..."
echo "└> Distribution: $DEPLOY_DISTRO"
echo "└> Window Manager: $DEPLOY_WM"

echo "Deploying library modules..."
lib-shell-utils::install
lib-theme::install
lib-wayland-utils::install

echo "Deploying theme modules..."
theme-base::install
theme-desktop::install

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

echo "Deploying desktop modules..."
alacritty::install
bitwarden::install
# bluetooth-autoconnect::install
chromium::install
direnv::install
disable-xdg-desktop-files::install
discord::install
draw.io::install
firefox::install
fontconfig::install
fuzzel::install
ghostty::install
gitui::install
imv::install
mako::install
mpv::install
pandoc::install
pyenv::install
qutebrowser::install
scripts-desktop::install
scripts-markdown::install
scripts-misc::install
scripts-system-utils::install
spotify::install
udiskie::install
vscodium::install
vt::install
waybar::install
way-displays::install
wezterm::install
wofi::install
xdg-mimetype-associations::install
yay::install
zathura::install

echo "Deploying window managers..."
if [[ $DEPLOY_WM == "hyprland" ]]; then
    hyprland::install
    hyprlock::install

elif [[ $DEPLOY_WM == "river" ]]; then
    river::install
    hyprlock::install

elif [[ $DEPLOY_WM == "sway" ]]; then
    sway::install
    hyprlock::install

fi

echo "Deploying desktop user services..."
# bluetooth-autoconnect::enable
pipewire::enable
ssh::enable
syncthing::enable
udiskie::enable

echo "...deployment complete."
