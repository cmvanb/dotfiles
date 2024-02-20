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

host=$HOSTNAME

echo "Applying \`$host\` configuration to \`$HOME\`."

# Supertubes
if [[ $host == "supertubes" ]]; then

    mkdir -p "$config_dir/yambar"
    esh "$base_dir/.config/yambar/config.yml~desktop" > "$config_dir/yambar/config.yml"

    mkdir -p "$config_dir/wallpaper"
    force_link "$base_dir/.config/wallpaper/wallpaper.sh~home-triple" "$config_dir/wallpaper/wallpaper.sh"

    mkdir -p "$config_dir/way-displays"
    force_link "$base_dir/.config/way-displays/cfg.yaml~home-triple" "$config_dir/way-displays/cfg.yaml"

    force_link "$base_dir/.local/bin/init~basic" "$bin_dir/init"

# Dojo
elif [[ $host == "dojo" ]]; then

    mkdir -p "$config_dir/yambar"
    esh "$base_dir/.config/yambar/config.yml~desktop" > "$config_dir/yambar/config.yml"

    # TODO: Add wallpaper config for Dojo.

    # TODO: Add display config for Dojo.

    force_link "$base_dir/.local/bin/init~basic" "$bin_dir/init"

# Qutedell
elif [[ $host == "qutedell" ]]; then

    mkdir -p "$config_dir/yambar"
    esh "$base_dir/.config/yambar/config.yml~laptop" > "$config_dir/yambar/config.yml"

    mkdir -p "$config_dir/wallpaper"
    force_link "$base_dir/.config/wallpaper/wallpaper.sh~qutech-dual" "$config_dir/wallpaper/wallpaper.sh"

    mkdir -p "$config_dir/way-displays"
    force_link "$base_dir/.config/way-displays/cfg.yaml~qutech-dual" "$config_dir/way-displays/cfg.yaml"

    force_link "$base_dir/.local/bin/init~basic" "$bin_dir/init"

# Cyxwel
elif [[ $host == "cyxwel" ]]; then

    mkdir -p "$config_dir/yambar"
    esh "$base_dir/.config/yambar/config.yml~desktop" > "$config_dir/yambar/config.yml"

    mkdir -p "$config_dir/wallpaper"
    force_link "$base_dir/.config/wallpaper/wallpaper.sh~home-triple" "$config_dir/wallpaper/wallpaper.sh"

    mkdir -p "$config_dir/way-displays"
    force_link "$base_dir/.config/way-displays/cfg.yaml~home-triple" "$config_dir/way-displays/cfg.yaml"

    force_link "$base_dir/.local/bin/init~basic" "$bin_dir/init"

# ...
else
    echo "[$(basename "$0")] ERROR: Did not recognize host: $host"
    exit 1
fi
