#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Link the dotfiles to the home directory
#-------------------------------------------------------------------------------

set -euo pipefail

bash_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
source_dir=$(realpath "$bash_dir/..")
home_dir=$HOME
bin_dir=${XDG_BIN_HOME:-$HOME/.local/bin}
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
data_dir=${XDG_DATA_HOME:-$HOME/.local/share}
scripts_dir=${XDG_SCRIPTS_HOME:-$HOME/.local/scripts}
templates_dir=${XDG_TEMPLATES_DIR:-$HOME/.local/templates}

# Imports
#-------------------------------------------------------------------------------

source "$source_dir/.local/scripts/fs-utils.sh"

# Link dotfiles
#-------------------------------------------------------------------------------

echo "Linking dotfiles from \`$source_dir\` to \`$home_dir\`."

# SSH configuration
mkdir -p "$home_dir/.ssh"
force_link "$source_dir/.ssh/config" "$home_dir/.ssh/config"

# Bin
mkdir -p $bin_dir
force_link "$source_dir/.local/bin/0x0" "$bin_dir/0x0"
force_link "$source_dir/.local/bin/browse" "$bin_dir/browse"
force_link "$source_dir/.local/bin/edit" "$bin_dir/edit"
force_link "$source_dir/.local/bin/fetchpw" "$bin_dir/fetchpw"
force_link "$source_dir/.local/bin/kebab" "$bin_dir/kebab"
force_link "$source_dir/.local/bin/kebabify" "$bin_dir/kebabify"
force_link "$source_dir/.local/bin/logout" "$bin_dir/logout"
force_link "$source_dir/.local/bin/printenv" "$bin_dir/printenv"
force_link "$source_dir/.local/bin/reboot" "$bin_dir/reboot"
force_link "$source_dir/.local/bin/river-run" "$bin_dir/river-run"
force_link "$source_dir/.local/bin/shutdown" "$bin_dir/shutdown"
force_link "$source_dir/.local/bin/view" "$bin_dir/view"
force_link "$source_dir/.local/bin/xdg-open" "$bin_dir/xdg-open"

# Scripts
mkdir -p $scripts_dir
force_link "$source_dir/.local/scripts/add-bookmark.sh" "$scripts_dir/add-bookmark.sh"
force_link "$source_dir/.local/scripts/color-hex-to-ansi.sh" "$scripts_dir/color-hex-to-ansi.sh"
force_link "$source_dir/.local/scripts/color-index-to-ansi.sh" "$scripts_dir/color-index-to-ansi.sh"
force_link "$source_dir/.local/scripts/debug-utils.sh" "$scripts_dir/debug-utils.sh"
force_link "$source_dir/.local/scripts/estimate-disk-space-usage.sh" "$scripts_dir/estimate-disk-space-usage.sh"
force_link "$source_dir/.local/scripts/fetch-password.sh" "$scripts_dir/fetch-password.sh"
force_link "$source_dir/.local/scripts/fs-utils.sh" "$scripts_dir/fs-utils.sh"
force_link "$source_dir/.local/scripts/generate-color-gradient-palette.py" "$scripts_dir/generate-color-gradient-palette.py"
force_link "$source_dir/.local/scripts/lock-screen.sh" "$scripts_dir/lock-screen.sh"
force_link "$source_dir/.local/scripts/kebabify.sh" "$scripts_dir/kebabify.sh"
force_link "$source_dir/.local/scripts/kill-yambar.sh" "$scripts_dir/kill-yambar.sh"
force_link "$source_dir/.local/scripts/markdown-to-html-on-changed.sh" "$scripts_dir/markdown-to-html-on-changed.sh"
force_link "$source_dir/.local/scripts/markdown-to-html.sh" "$scripts_dir/markdown-to-html.sh"
force_link "$source_dir/.local/scripts/matrix.sh" "$scripts_dir/matrix.sh"
force_link "$source_dir/.local/scripts/mimi.sh" "$scripts_dir/mimi.sh"
force_link "$source_dir/.local/scripts/name-formatting.sh" "$scripts_dir/name-formatting.sh"
force_link "$source_dir/.local/scripts/open-qutebrowser-session.sh" "$scripts_dir/open-qutebrowser-session.sh"
force_link "$source_dir/.local/scripts/path-utils.sh" "$scripts_dir/path-utils.sh"
force_link "$source_dir/.local/scripts/print-environment.py" "$scripts_dir/print-environment.py"
force_link "$source_dir/.local/scripts/print-terminal-colors.sh" "$scripts_dir/print-terminal-colors.sh"
force_link "$source_dir/.local/scripts/rename-kebabcase.sh" "$scripts_dir/rename-kebabcase.sh"
force_link "$source_dir/.local/scripts/screenshot-rectangle.sh" "$scripts_dir/screenshot-rectangle.sh"
force_link "$source_dir/.local/scripts/select-bookmark.sh" "$scripts_dir/select-bookmark.sh"
force_link "$source_dir/.local/scripts/set-terminal-title.sh" "$scripts_dir/set-terminal-title.sh"
force_link "$source_dir/.local/scripts/string-utils.sh" "$scripts_dir/string-utils.sh"
force_link "$source_dir/.local/scripts/terminal-preview.sh" "$scripts_dir/terminal-preview.sh"
force_link "$source_dir/.local/scripts/view.sh" "$scripts_dir/view.sh"
force_link "$source_dir/.local/scripts/view-stdin.sh" "$scripts_dir/view-stdin.sh"
force_link "$source_dir/.local/scripts/wl-get-output-transform.sh" "$scripts_dir/wl-get-output-transform.sh"
force_link "$source_dir/.local/scripts/wl-get-outputs.sh" "$scripts_dir/wl-get-outputs.sh"
force_link "$source_dir/.local/scripts/wl-rotate-display.sh" "$scripts_dir/wl-rotate-display.sh"

# Templates
mkdir -p $templates_dir
force_link "$source_dir/.local/templates/bookmark.md~esh" "$templates_dir/bookmark.md~esh"

# XDG .desktop files
mkdir -p $data_dir
mkdir -p "$data_dir/applications"
force_link "$source_dir/.local/share/applications/bitwarden.desktop" "$data_dir/applications/bitwarden.desktop"
force_link "$source_dir/.local/share/applications/chromium.desktop" "$data_dir/applications/chromium.desktop"
force_link "$source_dir/.local/share/applications/org.qutebrowser.qutebrowser.desktop" "$data_dir/applications/org.qutebrowser.qutebrowser.desktop"

# Application data
mkdir -p "$data_dir/qutebrowser/userscripts"
force_link "$source_dir/.local/share/qutebrowser/userscripts/format_json.sh" "$data_dir/qutebrowser/userscripts/format_json.sh"
force_link "$source_dir/.local/share/qutebrowser/userscripts/readability.py" "$data_dir/qutebrowser/userscripts/readability.py"
force_link "$source_dir/.local/share/pandoc" "$data_dir/pandoc"

# Configuration
mkdir -p "$config_dir"
force_link "$source_dir/.config/bash" "$config_dir/bash"
mkdir -p "$config_dir/bat"
force_link "$source_dir/.config/bat/config" "$config_dir/bat/config"
force_link "$source_dir/.config/bat/syntaxes" "$config_dir/bat/syntaxes"
# NOTE: Don't symlink Bitwarden config because it will be overwritten by the app.
cp -nr "$source_dir/.config/Bitwarden" "$config_dir/Bitwarden" && true
force_link "$source_dir/.config/fish/config.fish" "$config_dir/fish/config.fish"
force_link "$source_dir/.config/fish/env.fish" "$config_dir/fish/env.fish"
force_link "$source_dir/.config/fish/interactive.fish" "$config_dir/fish/interactive.fish"
force_link "$source_dir/.config/fish/login.fish" "$config_dir/fish/login.fish"
force_link "$source_dir/.config/fish/logout.fish" "$config_dir/fish/logout.fish"
force_link "$source_dir/.config/fish/functions" "$config_dir/fish/functions"
force_link "$source_dir/.config/git" "$config_dir/git"
force_link "$source_dir/.config/imv" "$config_dir/imv"
force_link "$source_dir/.config/lf" "$config_dir/lf"
force_link "$source_dir/.config/mpv" "$config_dir/mpv"
force_link "$source_dir/.config/nvim" "$config_dir/nvim"
mkdir -p "$config_dir/qutebrowser"
force_link "$source_dir/.config/qutebrowser/config.py" "$config_dir/qutebrowser/config.py"
force_link "$source_dir/.config/qutebrowser/stylesheet.css" "$config_dir/qutebrowser/stylesheet.css"
force_link "$source_dir/.config/ripgrep" "$config_dir/ripgrep"
force_link "$source_dir/.config/river" "$config_dir/river"
force_link "$source_dir/.config/shell" "$config_dir/shell"
mkdir -p "$config_dir/syncthing"
force_link "$source_dir/.config/syncthing/config.xml" "$config_dir/syncthing/config.xml"
mkdir -p "$config_dir/systemd/user"
force_link "$source_dir/.config/systemd/user/river-session.target" "$config_dir/systemd/user/river-session.target"
force_link "$source_dir/.config/systemd/user/wayland-session.target" "$config_dir/systemd/user/wayland-session.target"
force_link "$source_dir/.config/theme" "$config_dir/theme"
force_link "$source_dir/.config/vt" "$config_dir/vt"
force_link "$source_dir/.config/wezterm" "$config_dir/wezterm"
mkdir -p "$config_dir/wofi"
force_link "$source_dir/.config/wofi/config" "$config_dir/wofi/config"
force_link "$source_dir/.config/zathura" "$config_dir/zathura"
