#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Generate configuration files from templates
#-------------------------------------------------------------------------------

set -euo pipefail

if ! command -v esh &> /dev/null; then
    echo "[$(basename "$0")] ERROR: Missing dependency: esh"
    exit 1
fi

bash_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source_dir=$( realpath "$bash_dir/.." )
home_dir=$HOME
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

echo "Generating dotfiles templates from \`$source_dir\` to \`$home_dir\`."

# Generate dotfiles templates
#-------------------------------------------------------------------------------

mkdir -p "$config_dir/mako"
esh "$source_dir/.config/mako/config~esh" > "$config_dir/mako/config"

mkdir -p "$config_dir/wofi"
esh "$source_dir/.config/wofi/style.css~esh" > "$config_dir/wofi/style.css"

# TODO: Make this cross platform.
export SYSTEM_BINARY_PATH=/run/current-system/sw/bin

mkdir -p "$config_dir/systemd/user"
esh "$source_dir/.config/systemd/user/mako.service~esh" > "$config_dir/systemd/user/mako.service"
esh "$source_dir/.config/systemd/user/ssh-agent.service~esh" > "$config_dir/systemd/user/ssh-agent.service"
esh "$source_dir/.config/systemd/user/udiskie.service~esh" > "$config_dir/systemd/user/udiskie.service"
