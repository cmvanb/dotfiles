#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Link the dotfiles to the home directory
#-------------------------------------------------------------------------------

set -euo pipefail

base_dir="$(realpath "$(dirname "$(realpath "$0")")/..")"

# Imports
#-------------------------------------------------------------------------------

source "$base_dir/.local/opt/shell-utils/fs.sh"

# Constants
#-------------------------------------------------------------------------------

home_dir=$HOME
bin_dir=${XDG_BIN_HOME:-$HOME/.local/bin}
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
data_dir=${XDG_DATA_HOME:-$HOME/.local/share}
opt_dir=${XDG_OPT_HOME:-$HOME/.local/opt}
scripts_dir=${XDG_SCRIPTS_HOME:-$HOME/.local/scripts}
templates_dir=${XDG_TEMPLATES_DIR:-$data_dir/templates}

# Link dotfiles
#-------------------------------------------------------------------------------

echo "Linking dotfiles from \`$base_dir\` to \`$home_dir\`."

# SSH configuration
mkdir -p "$home_dir/.ssh"
force_link "$base_dir/.ssh/config" "$home_dir/.ssh/config"

# Bin
mkdir -p "$bin_dir"
force_link "$base_dir/.local/bin/0x0" "$bin_dir/0x0"
force_link "$base_dir/.local/bin/browse" "$bin_dir/browse"
force_link "$base_dir/.local/bin/edit" "$bin_dir/edit"
force_link "$base_dir/.local/bin/fetchpw" "$bin_dir/fetchpw"
force_link "$base_dir/.local/bin/kebab" "$bin_dir/kebab"
force_link "$base_dir/.local/bin/kebabify" "$bin_dir/kebabify"
force_link "$base_dir/.local/bin/logout" "$bin_dir/logout"
force_link "$base_dir/.local/bin/printenv" "$bin_dir/printenv"
force_link "$base_dir/.local/bin/reboot" "$bin_dir/reboot"
force_link "$base_dir/.local/bin/river-run" "$bin_dir/river-run"
force_link "$base_dir/.local/bin/shutdown" "$bin_dir/shutdown"
force_link "$base_dir/.local/bin/view" "$bin_dir/view"

# Scripts
mkdir -p "$scripts_dir"
force_link "$base_dir/.local/scripts/add-bookmark.sh" "$scripts_dir/add-bookmark.sh"
force_link "$base_dir/.local/scripts/estimate-disk-space-usage.sh" "$scripts_dir/estimate-disk-space-usage.sh"
force_link "$base_dir/.local/scripts/fetch-password.sh" "$scripts_dir/fetch-password.sh"
force_link "$base_dir/.local/scripts/format-text.sh" "$scripts_dir/format-text.sh"
force_link "$base_dir/.local/scripts/generate-color-gradient-palette.py" "$scripts_dir/generate-color-gradient-palette.py"
force_link "$base_dir/.local/scripts/generate-venv.sh" "$scripts_dir/generate-venv.sh"
force_link "$base_dir/.local/scripts/kebabify.sh" "$scripts_dir/kebabify.sh"
force_link "$base_dir/.local/scripts/lock-screen.sh" "$scripts_dir/lock-screen.sh"
force_link "$base_dir/.local/scripts/markdown-to-html-on-changed.sh" "$scripts_dir/markdown-to-html-on-changed.sh"
force_link "$base_dir/.local/scripts/markdown-to-html.sh" "$scripts_dir/markdown-to-html.sh"
force_link "$base_dir/.local/scripts/matrix.sh" "$scripts_dir/matrix.sh"
force_link "$base_dir/.local/scripts/open-qutebrowser-session.sh" "$scripts_dir/open-qutebrowser-session.sh"
force_link "$base_dir/.local/scripts/print-environment.py" "$scripts_dir/print-environment.py"
force_link "$base_dir/.local/scripts/print-terminal-colors.sh" "$scripts_dir/print-terminal-colors.sh"
force_link "$base_dir/.local/scripts/rename-kebabcase.sh" "$scripts_dir/rename-kebabcase.sh"
force_link "$base_dir/.local/scripts/screenshot-rectangle.sh" "$scripts_dir/screenshot-rectangle.sh"
force_link "$base_dir/.local/scripts/select-bookmark.sh" "$scripts_dir/select-bookmark.sh"
force_link "$base_dir/.local/scripts/set-terminal-title.sh" "$scripts_dir/set-terminal-title.sh"
force_link "$base_dir/.local/scripts/terminal-preview.sh" "$scripts_dir/terminal-preview.sh"
force_link "$base_dir/.local/scripts/view.sh" "$scripts_dir/view.sh"
force_link "$base_dir/.local/scripts/vlc-webcam-test.sh" "$scripts_dir/vlc-webcam-test.sh"

# Shell libraries
mkdir -p "$opt_dir/shell-utils"
force_link "$base_dir/.local/opt/shell-utils" "$opt_dir/shell-utils"
force_link "$base_dir/.local/opt/wayland-utils" "$opt_dir/wayland-utils"

# Templates
mkdir -p "$templates_dir"
force_link "$base_dir/.local/share/templates/bookmark.md~esh" "$templates_dir/bookmark.md~esh"

# XDG .desktop files
mkdir -p "$data_dir"
mkdir -p "$data_dir/applications"
force_link "$base_dir/.local/share/applications/bitwarden.desktop" "$data_dir/applications/bitwarden.desktop"
force_link "$base_dir/.local/share/applications/chromium.desktop" "$data_dir/applications/chromium.desktop"
force_link "$base_dir/.local/share/applications/lf.desktop" "$data_dir/applications/lf.desktop"
force_link "$base_dir/.local/share/applications/org.qutebrowser.qutebrowser.desktop" "$data_dir/applications/org.qutebrowser.qutebrowser.desktop"
force_link "$base_dir/.local/share/applications/org.pwmt.zathura.desktop" "$data_dir/applications/org.pwmt.zathura.desktop"

# Disabled XDG .desktop files
force_link "$base_dir/.local/share/applications/avahi-discover.desktop" "$data_dir/applications/avahi-discover.desktop"
force_link "$base_dir/.local/share/applications/bssh.desktop" "$data_dir/applications/bssh.desktop"
force_link "$base_dir/.local/share/applications/bvnc.desktop" "$data_dir/applications/bvnc.desktop"
force_link "$base_dir/.local/share/applications/cmake-gui.desktop" "$data_dir/applications/cmake-gui.desktop"
force_link "$base_dir/.local/share/applications/electron24.desktop" "$data_dir/applications/electron24.desktop"
force_link "$base_dir/.local/share/applications/lstopo.desktop" "$data_dir/applications/lstopo.desktop"
force_link "$base_dir/.local/share/applications/qv4l2.desktop" "$data_dir/applications/qv4l2.desktop"
force_link "$base_dir/.local/share/applications/qvidcap.desktop" "$data_dir/applications/qvidcap.desktop"

# Application data
mkdir -p "$data_dir/qutebrowser/userscripts"
force_link "$base_dir/.local/share/qutebrowser/userscripts/format_json.sh" "$data_dir/qutebrowser/userscripts/format_json.sh"
force_link "$base_dir/.local/share/qutebrowser/userscripts/readability.py" "$data_dir/qutebrowser/userscripts/readability.py"
force_link "$base_dir/.local/share/pandoc" "$data_dir/pandoc"

# Configuration
mkdir -p "$config_dir"
force_link "$base_dir/.config/mimeapps.list" "$config_dir/mimeapps.list"
mkdir -p "$config_dir/bash"
force_link "$base_dir/.config/bash/bash_profile" "$config_dir/bash/bash_profile"
force_link "$base_dir/.config/bash/bashrc" "$config_dir/bash/bashrc"
force_link "$base_dir/.config/bash/env.sh" "$config_dir/bash/env.sh"
force_link "$base_dir/.config/bash/interactive.sh" "$config_dir/bash/interactive.sh"
force_link "$base_dir/.config/bash/login.sh" "$config_dir/bash/login.sh"
force_link "$base_dir/.config/bash/logout.sh" "$config_dir/bash/logout.sh"
force_link "$base_dir/.config/bash/prompt.sh" "$config_dir/bash/prompt.sh"
mkdir -p "$config_dir/bat"
force_link "$base_dir/.config/bat/config" "$config_dir/bat/config"
force_link "$base_dir/.config/bat/syntaxes" "$config_dir/bat/syntaxes"
# NOTE: Don't symlink Bitwarden config because it will be overwritten by the app.
cp -nr "$base_dir/.config/Bitwarden" "$config_dir/Bitwarden" && true
force_link "$base_dir/.config/direnv" "$config_dir/direnv"
mkdir -p "$config_dir/fish"
force_link "$base_dir/.config/fish/config.fish" "$config_dir/fish/config.fish"
force_link "$base_dir/.config/fish/env.fish" "$config_dir/fish/env.fish"
force_link "$base_dir/.config/fish/interactive.fish" "$config_dir/fish/interactive.fish"
force_link "$base_dir/.config/fish/login.fish" "$config_dir/fish/login.fish"
force_link "$base_dir/.config/fish/logout.fish" "$config_dir/fish/logout.fish"
force_link "$base_dir/.config/fish/functions" "$config_dir/fish/functions"
force_link "$base_dir/.config/git" "$config_dir/git"
force_link "$base_dir/.config/imv" "$config_dir/imv"
force_link "$base_dir/.config/lf" "$config_dir/lf"
force_link "$base_dir/.config/mpv" "$config_dir/mpv"
force_link "$base_dir/.config/nvim" "$config_dir/nvim"
force_link "$base_dir/.config/python" "$config_dir/python"
mkdir -p "$config_dir/hypr"
force_link "$base_dir/.config/hypr/hyprland.conf" "$config_dir/hypr/hyprland.conf"
mkdir -p "$config_dir/pip"
force_link "$base_dir/.config/pip/pip.conf" "$config_dir/pip/pip.conf"
mkdir -p "$config_dir/qutebrowser"
force_link "$base_dir/.config/qutebrowser/config.py" "$config_dir/qutebrowser/config.py"
force_link "$base_dir/.config/qutebrowser/stylesheet.css" "$config_dir/qutebrowser/stylesheet.css"
force_link "$base_dir/.config/ripgrep" "$config_dir/ripgrep"
mkdir -p "$config_dir/river"
force_link "$base_dir/.config/river/environment.sh" "$config_dir/river/environment.sh"
force_link "$base_dir/.config/river/init" "$config_dir/river/init"
force_link "$base_dir/.config/river/send-and-focus-output.sh" "$config_dir/river/send-and-focus-output.sh"
force_link "$base_dir/.config/river/send-to-output.sh" "$config_dir/river/send-to-output.sh"
force_link "$base_dir/.config/shell" "$config_dir/shell"
mkdir -p "$config_dir/systemd/user"
force_link "$base_dir/.config/systemd/user/river-session.target" "$config_dir/systemd/user/river-session.target"
force_link "$base_dir/.config/systemd/user/wayland-session.target" "$config_dir/systemd/user/wayland-session.target"
force_link "$base_dir/.config/systemd/user/xdg-desktop-portal-gtk.service" "$config_dir/systemd/user/xdg-desktop-portal-gtk.service"
mkdir -p "$config_dir/theme"
force_link "$base_dir/.config/theme/carbon-dark" "$config_dir/theme/carbon-dark"
force_link "$base_dir/.config/theme/carbon-light" "$config_dir/theme/carbon-light"
force_link "$base_dir/.config/vt" "$config_dir/vt"
force_link "$base_dir/.config/wezterm" "$config_dir/wezterm"
mkdir -p "$config_dir/xdg-desktop-portal"
force_link "$base_dir/.config/xdg-desktop-portal/river-portals.conf" "$config_dir/xdg-desktop-portal/river-portals.conf"
mkdir -p "$config_dir/waybar"
force_link "$base_dir/.config/waybar/config" "$config_dir/waybar/config"
mkdir -p "$config_dir/wofi"
force_link "$base_dir/.config/wofi/config" "$config_dir/wofi/config"
