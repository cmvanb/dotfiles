#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Link the dotfiles to the home directory
#-------------------------------------------------------------------------------

set -euo pipefail

# Setup
#-------------------------------------------------------------------------------

home_dir=$HOME
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source_dir=$( realpath "$script_dir/.." )

echo "Linking dotfiles from \`$source_dir\` to \`$home_dir\`."

bin_dir=${XDG_BIN_HOME:-$HOME/.local/bin}
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
data_dir=${XDG_DATA_HOME:-$HOME/.local/share}
scripts_dir=${XDG_SCRIPTS_HOME:-$HOME/.local/scripts}

# Create directories if necessary.
mkdir -p $bin_dir
mkdir -p $config_dir
mkdir -p $data_dir
mkdir -p $scripts_dir

# Link dotfiles
#-------------------------------------------------------------------------------

# Shell configuration
ln -sfT "$source_dir/.profile" "$home_dir/.profile"

# SSH configuration
mkdir -p "$home_dir/.ssh"
ln -sfT "$source_dir/.ssh/config" "$home_dir/.ssh/config"

# .desktop files
mkdir -p "$data_dir/applications"
ln -sfT "$source_dir/.local/share/applications/org.qutebrowser.qutebrowser.desktop" "$data_dir/applications/org.qutebrowser.qutebrowser.desktop"

# Bin
ln -sfT "$source_dir/.local/bin/0x0" "$bin_dir/0x0"
ln -sfT "$source_dir/.local/bin/edit" "$bin_dir/edit"
ln -sfT "$source_dir/.local/bin/fetchpw" "$bin_dir/fetchpw"
ln -sfT "$source_dir/.local/bin/kebab" "$bin_dir/kebab"
ln -sfT "$source_dir/.local/bin/kebabify" "$bin_dir/kebabify"
ln -sfT "$source_dir/.local/bin/logout" "$bin_dir/logout"
ln -sfT "$source_dir/.local/bin/printenv" "$bin_dir/printenv"
ln -sfT "$source_dir/.local/bin/reboot" "$bin_dir/reboot"
ln -sfT "$source_dir/.local/bin/river-run" "$bin_dir/river-run"
ln -sfT "$source_dir/.local/bin/rg" "$bin_dir/rg"
ln -sfT "$source_dir/.local/bin/shutdown" "$bin_dir/shutdown"
ln -sfT "$source_dir/.local/bin/xdg-open" "$bin_dir/xdg-open"

# Scripts
ln -sfT "$source_dir/.local/scripts/color-hex-to-ansi.sh" "$scripts_dir/color-hex-to-ansi.sh"
ln -sfT "$source_dir/.local/scripts/color-index-to-ansi.sh" "$scripts_dir/color-index-to-ansi.sh"
ln -sfT "$source_dir/.local/scripts/estimate-disk-space-usage.sh" "$scripts_dir/estimate-disk-space-usage.sh"
ln -sfT "$source_dir/.local/scripts/fetch-password.sh" "$scripts_dir/fetch-password.sh"
ln -sfT "$source_dir/.local/scripts/generate-color-gradient-palette.py" "$scripts_dir/generate-color-gradient-palette.py"
ln -sfT "$source_dir/.local/scripts/lock-screen.sh" "$scripts_dir/lock-screen.sh"
ln -sfT "$source_dir/.local/scripts/kebabify.sh" "$scripts_dir/kebabify.sh"
ln -sfT "$source_dir/.local/scripts/kill-yambar.sh" "$scripts_dir/kill-yambar.sh"
ln -sfT "$source_dir/.local/scripts/markdown-to-html-on-changed.sh" "$scripts_dir/markdown-to-html-on-changed.sh"
ln -sfT "$source_dir/.local/scripts/markdown-to-html.sh" "$scripts_dir/markdown-to-html.sh"
ln -sfT "$source_dir/.local/scripts/mimi.sh" "$scripts_dir/mimi.sh"
ln -sfT "$source_dir/.local/scripts/name-formatting.sh" "$scripts_dir/name-formatting.sh"
ln -sfT "$source_dir/.local/scripts/path-utils.sh" "$scripts_dir/path-utils.sh"
ln -sfT "$source_dir/.local/scripts/print-environment.py" "$scripts_dir/print-environment.py"
ln -sfT "$source_dir/.local/scripts/print-terminal-colors.sh" "$scripts_dir/print-terminal-colors.sh"
ln -sfT "$source_dir/.local/scripts/rename-kebabcase.sh" "$scripts_dir/rename-kebabcase.sh"
ln -sfT "$source_dir/.local/scripts/screenshot-rectangle.sh" "$scripts_dir/screenshot-rectangle.sh"
ln -sfT "$source_dir/.local/scripts/terminal-preview.sh" "$scripts_dir/terminal-preview.sh"
ln -sfT "$source_dir/.local/scripts/wl-get-output-transform.sh" "$scripts_dir/wl-get-output-transform.sh"
ln -sfT "$source_dir/.local/scripts/wl-get-outputs.sh" "$scripts_dir/wl-get-outputs.sh"
ln -sfT "$source_dir/.local/scripts/wl-rotate-display.sh" "$scripts_dir/wl-rotate-display.sh"

# AppData
mkdir -p "$data_dir/qutebrowser/userscripts"
ln -sfT "$source_dir/.local/share/qutebrowser/userscripts/readability.py" "$data_dir/qutebrowser/userscripts/readability.py"
ln -sfT "$source_dir/.local/share/pandoc" "$data_dir/pandoc"

# Configuration
# TODO: Include vimium local storage.
ln -sfT "$source_dir/.config/bash" "$config_dir/bash"
ln -sfT "$source_dir/.config/bat" "$config_dir/bat"
ln -sfT "$source_dir/.config/fish/config.fish" "$config_dir/fish/config.fish"
ln -sfT "$source_dir/.config/fish/functions" "$config_dir/fish/functions"
ln -sfT "$source_dir/.config/git" "$config_dir/git"
ln -sfT "$source_dir/.config/imv" "$config_dir/imv"
ln -sfT "$source_dir/.config/lf" "$config_dir/lf"
ln -sfT "$source_dir/.config/mpv" "$config_dir/mpv"
ln -sfT "$source_dir/.config/nvim" "$config_dir/nvim"
mkdir -p "$config_dir/qutebrowser"
ln -sfT "$source_dir/.config/qutebrowser/config.py" "$config_dir/qutebrowser/config.py"
ln -sfT "$source_dir/.config/qutebrowser/stylesheet.css" "$config_dir/qutebrowser/stylesheet.css"
ln -sfT "$source_dir/.config/ripgrep" "$config_dir/ripgrep"
ln -sfT "$source_dir/.config/river" "$config_dir/river"
ln -sfT "$source_dir/.config/shell" "$config_dir/shell"
mkdir -p "$config_dir/syncthing"
ln -sfT "$source_dir/.config/syncthing/config.xml" "$config_dir/syncthing/config.xml"
ln -sfT "$source_dir/.config/theme" "$config_dir/theme"
ln -sfT "$source_dir/.config/wezterm" "$config_dir/wezterm"
mkdir -p "$config_dir/wofi"
ln -sfT "$source_dir/.config/wofi/config" "$config_dir/wofi/config"
ln -sfT "$source_dir/.config/zathura" "$config_dir/zathura"
