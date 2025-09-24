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
source "$base_dir/config/lib-shell-utils/fs.sh"
source "$base_dir/config/lib-shell-utils/linux.sh"

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
export DEPLOY_WM="river"

# Determine which shell the template engine executes
export ESH_SHELL=/usr/bin/bash

# Load shell library modules
source "$base_dir/deploy/modules/lib-shell-utils.sh"
source "$base_dir/deploy/modules/lib-theme.sh"
source "$base_dir/deploy/modules/lib-wayland-utils.sh"

# Load theme modules
source "$base_dir/deploy/modules/theme-base.sh"
source "$base_dir/deploy/modules/theme-desktop.sh"

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
source "$base_dir/deploy/modules/shell-stty.sh"
source "$base_dir/deploy/modules/wget.sh"
source "$base_dir/deploy/modules/yazi.sh"

# Load desktop deployment modules
source "$base_dir/deploy/modules/alacritty.sh"
source "$base_dir/deploy/modules/bitwarden.sh"
source "$base_dir/deploy/modules/bluetooth-autoconnect.sh"
source "$base_dir/deploy/modules/chromium.sh"
source "$base_dir/deploy/modules/direnv.sh"
source "$base_dir/deploy/modules/disable-xdg-desktop-files.sh"
source "$base_dir/deploy/modules/discord.sh"
source "$base_dir/deploy/modules/draw.io.sh"
source "$base_dir/deploy/modules/firefox.sh"
source "$base_dir/deploy/modules/fontconfig.sh"
source "$base_dir/deploy/modules/fuzzel.sh"
source "$base_dir/deploy/modules/ghostty.sh"
source "$base_dir/deploy/modules/hyprland.sh"
source "$base_dir/deploy/modules/hyprlock.sh"
source "$base_dir/deploy/modules/imv.sh"
source "$base_dir/deploy/modules/mako.sh"
source "$base_dir/deploy/modules/mpv.sh"
source "$base_dir/deploy/modules/pandoc.sh"
source "$base_dir/deploy/modules/pipewire.sh"
source "$base_dir/deploy/modules/pyenv.sh"
source "$base_dir/deploy/modules/qutebrowser.sh"
source "$base_dir/deploy/modules/river.sh"
source "$base_dir/deploy/modules/scripts-desktop.sh"
source "$base_dir/deploy/modules/scripts-markdown.sh"
source "$base_dir/deploy/modules/scripts-misc.sh"
source "$base_dir/deploy/modules/scripts-system-utils.sh"
source "$base_dir/deploy/modules/ssh.sh"
source "$base_dir/deploy/modules/syncthing.sh"
source "$base_dir/deploy/modules/spotify.sh"
source "$base_dir/deploy/modules/udiskie.sh"
source "$base_dir/deploy/modules/vscodium.sh"
source "$base_dir/deploy/modules/vt.sh"
source "$base_dir/deploy/modules/waybar.sh"
source "$base_dir/deploy/modules/way-displays.sh"
source "$base_dir/deploy/modules/wezterm.sh"
source "$base_dir/deploy/modules/wofi.sh"
source "$base_dir/deploy/modules/xdg-mimetype-associations.sh"
source "$base_dir/deploy/modules/yay.sh"
source "$base_dir/deploy/modules/zathura.sh"

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
shell-stty::install
wget::install
yazi::install

echo "Deploying desktop modules..."
alacritty::install
bitwarden::install
bluetooth-autoconnect::install
chromium::install
direnv::install
disable-xdg-desktop-files::install
discord::install
draw.io::install
firefox::install
fontconfig::install
ghostty::install
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

fi

echo "Deploying desktop user services..."
bluetooth-autoconnect::enable
pipewire::enable
ssh::enable
syncthing::enable
udiskie::enable

echo "...deployment complete."
