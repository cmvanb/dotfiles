#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Generate configuration files from templates
#-------------------------------------------------------------------------------

set -euo pipefail

bash_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
source_dir=$(realpath "$bash_dir/..")

# Imports
#-------------------------------------------------------------------------------

source "$source_dir/.local/scripts/debug-utils.sh"

# Validation
#-------------------------------------------------------------------------------

assert_dependency esh
assert_dependency bat

# Generate dotfiles templates
#-------------------------------------------------------------------------------

bin_dir=${XDG_BIN_HOME:-$HOME/.local/bin}
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

echo "Generating dotfiles templates from \`$source_dir\` to \`$HOME\`."

mkdir -p "$bin_dir"
esh "$source_dir/.local/bin/rg~esh" > "$bin_dir/rg"
chmod +x "$bin_dir/rg"

mkdir -p "$config_dir/alacritty"
esh "$source_dir/.config/alacritty/alacritty.yml~esh" > "$config_dir/alacritty/alacritty.yml"

mkdir -p "$config_dir/bat/themes"
esh "$source_dir/.config/theme/carbon-dark.tmTheme~esh" > "$config_dir/bat/themes/carbon-dark.tmTheme"
/usr/bin/bat cache --build

mkdir -p "$config_dir/mako"
esh "$source_dir/.config/mako/config~esh" > "$config_dir/mako/config"

mkdir -p "$config_dir/wofi"
esh "$source_dir/.config/wofi/style.css~esh" > "$config_dir/wofi/style.css"

mkdir -p "$config_dir/systemd/user"
esh "$source_dir/.config/systemd/user/mako.service~esh" > "$config_dir/systemd/user/mako.service"
esh "$source_dir/.config/systemd/user/ssh-agent.service~esh" > "$config_dir/systemd/user/ssh-agent.service"
esh "$source_dir/.config/systemd/user/udiskie.service~esh" > "$config_dir/systemd/user/udiskie.service"
