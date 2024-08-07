#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Generate configuration files from templates
#-------------------------------------------------------------------------------

base_dir="$(realpath "$(dirname "$(realpath "$0")")/..")"

# Imports
#-------------------------------------------------------------------------------

source "$base_dir/.local/opt/shell-utils/debug.sh"

# Validation
#-------------------------------------------------------------------------------

assert_dependency esh

# Generate dotfiles templates
#-------------------------------------------------------------------------------

bin_dir=${XDG_BIN_HOME:-$HOME/.local/bin}
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
data_dir=${XDG_DATA_HOME:-$HOME/.local/share}

echo "Generating dotfiles templates from \`$base_dir\` to \`$HOME\`."

mkdir -p "$bin_dir"
esh "$base_dir/.local/bin/rg~esh" > "$bin_dir/rg"
chmod +x "$bin_dir/rg"

mkdir -p "$config_dir/alacritty"
esh "$base_dir/.config/alacritty/alacritty.toml~esh" > "$config_dir/alacritty/alacritty.toml"

mkdir -p "$config_dir/btop/themes"
esh "$base_dir/.config/btop/themes/carbon.theme~esh" > "$config_dir/btop/themes/carbon.theme"

mkdir -p "$config_dir/fontconfig"
esh "$base_dir/.config/fontconfig/fonts.conf~esh" > "$config_dir/fontconfig/fonts.conf"

mkdir -p "$config_dir/mako"
esh "$base_dir/.config/mako/config~esh" > "$config_dir/mako/config"

mkdir -p "$config_dir/waybar"
esh "$base_dir/.config/waybar/style.css~esh" > "$config_dir/waybar/style.css"

mkdir -p "$config_dir/wofi"
esh "$base_dir/.config/wofi/style.css~esh" > "$config_dir/wofi/style.css"

mkdir -p "$config_dir/systemd/user"
esh "$base_dir/.config/systemd/user/mako.service~esh" > "$config_dir/systemd/user/mako.service"
esh "$base_dir/.config/systemd/user/ssh-agent.service~esh" > "$config_dir/systemd/user/ssh-agent.service"
esh "$base_dir/.config/systemd/user/udiskie.service~esh" > "$config_dir/systemd/user/udiskie.service"

mkdir -p "$config_dir/zathura"
esh "$base_dir/.config/zathura/zathurarc~esh" > "$config_dir/zathura/zathurarc"

mkdir -p "$data_dir/applications"
esh "$base_dir/.local/share/applications/draw.io.desktop~esh" > "$data_dir/applications/draw.io.desktop"
