#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Apply host-specific configuration templates and links
#-------------------------------------------------------------------------------

set -euo pipefail

base_dir="$(realpath "$(dirname "$(realpath "$0")")/..")"

# Imports
#-------------------------------------------------------------------------------

source "$base_dir/.local/opt/shell-utils/debug.sh"
source "$base_dir/.local/opt/shell-utils/fs.sh"

# Validation
#-------------------------------------------------------------------------------

assert_dependency esh

# Host-specific configuration
#-------------------------------------------------------------------------------

config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
bin_dir=${XDG_BIN_HOME:-$HOME/.local/bin}

host=$(uname -n)

echo "Applying \`$host\` configuration to \`$HOME\`."

case $host in

qutedell)
    mkdir -p "$config_dir/river"
    force_link "$base_dir/.config/river/workspace.sh~qutech-dual" "$config_dir/river/workspace.sh"

    mkdir -p "$config_dir/wallpaper"
    force_link "$base_dir/.config/wallpaper/wallpaper.sh~qutech-dual" "$config_dir/wallpaper/wallpaper.sh"

    mkdir -p "$config_dir/way-displays"
    force_link "$base_dir/.config/way-displays/cfg.yaml~qutech-dual" "$config_dir/way-displays/cfg.yaml"

    force_link "$base_dir/.local/bin/init~river" "$bin_dir/init"
    ;;

supertubes)
    ;&
cyxwel)
    mkdir -p "$config_dir/river"
    force_link "$base_dir/.config/river/workspace.sh~home-triple" "$config_dir/river/workspace.sh"

    mkdir -p "$config_dir/wallpaper"
    force_link "$base_dir/.config/wallpaper/wallpaper.sh~home-triple" "$config_dir/wallpaper/wallpaper.sh"

    mkdir -p "$config_dir/way-displays"
    force_link "$base_dir/.config/way-displays/cfg.yaml~home-triple" "$config_dir/way-displays/cfg.yaml"

    force_link "$base_dir/.local/bin/init~river" "$bin_dir/init"
    ;;

*)
    echo "[$(basename "$0")] ERROR: Did not recognize host: $host"
    exit 1
    ;;

esac
