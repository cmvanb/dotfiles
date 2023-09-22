#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Apply host-specific configuration templates and links
#-------------------------------------------------------------------------------

set -euo pipefail

# Imports
#-------------------------------------------------------------------------------

source "$source_dir/.local/scripts/debug-utils.sh"
source "$source_dir/.local/scripts/fs-utils.sh"

# Validation
#-------------------------------------------------------------------------------

assert_dependency esh

# Host-specific configuration
#-------------------------------------------------------------------------------

bash_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
source_dir=$(realpath "$bash_dir/..")
home_dir=$HOME
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

host=$HOSTNAME

echo "Applying \`$host\` configuration to \`$home_dir\`."

# Supertubes
if [[ $host == "supertubes" ]]; then

    mkdir -p "$config_dir/yambar"
    esh "$source_dir/.config/yambar/config.yml~desktop" > "$config_dir/yambar/config.yml"
    mkdir -p "$config_dir/way-displays"
    force_link "$source_dir/.config/way-displays/cfg.yaml~home-dual" "$config_dir/way-displays/cfg.yaml"

# Dojo
elif [[ $host == "dojo" ]]; then

    mkdir -p "$config_dir/yambar"
    esh "$source_dir/.config/yambar/config.yml~desktop" > "$config_dir/yambar/config.yml"

# Qutedell
elif [[ $host == "qutedell" ]]; then

    mkdir -p "$config_dir/yambar"
    esh "$source_dir/.config/yambar/config.yml~laptop" > "$config_dir/yambar/config.yml"
    mkdir -p "$config_dir/way-displays"
    force_link "$source_dir/.config/way-displays/cfg.yaml~qutech-dual" "$config_dir/way-displays/cfg.yaml"

# ...
else
    echo "[$(basename "$0")] ERROR: Did not recognize host: $host"
    exit 1
fi

