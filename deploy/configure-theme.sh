#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy the theme configuration
#-------------------------------------------------------------------------------

set -euo pipefail

base_dir="$(realpath "$(dirname "$(realpath "$0")")/..")"
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
opt_dir=${XDG_OPT_HOME:-$HOME/.local/opt}

# Imports
#-------------------------------------------------------------------------------

source "$base_dir/.local/opt/shell-utils/debug.sh"
source "$base_dir/.local/opt/shell-utils/fs.sh"

# Validation
#-------------------------------------------------------------------------------

assert_dependency bat

# Install system theme scripts
#-------------------------------------------------------------------------------

mkdir -p "$opt_dir/theme"
force_link "$base_dir/.local/opt/theme" "$opt_dir/theme"

# Select system theme
#-------------------------------------------------------------------------------

echo "Linking selected theme colors."

force_link "$config_dir/theme/carbon-dark" "$config_dir/theme/colors"

# Link theme variables
#-------------------------------------------------------------------------------

echo "Link theme variables."

force_link "$base_dir/.config/theme/cursor" "$config_dir/theme/cursor"

# Link host-specific theme variables
#-------------------------------------------------------------------------------

host=$(uname -n)

echo "Link \`$host\` specific theme variables."

case $host in

qutedell)
    force_link "$base_dir/.config/theme/fonts~qutech" "$config_dir/theme/fonts"
    ;;

supertubes)
    ;&
cyxwel)
    force_link "$base_dir/.config/theme/fonts~home" "$config_dir/theme/fonts"
    ;;

*)
    echo "[$(basename "$0")] ERROR: Did not recognize host: $host"
    exit 1
    ;;

esac

# Generate theme templates
#-------------------------------------------------------------------------------

echo "Generating theme templates."

mkdir -p "$config_dir/bat/themes"
esh "$base_dir/.config/theme/carbon-dark.tmTheme~esh" > "$config_dir/bat/themes/carbon-dark.tmTheme"

mkdir -p "$config_dir/theme"
esh "$base_dir/.config/theme/dircolors~esh" > "$config_dir/theme/dircolors"
esh "$base_dir/.config/theme/eza-colors~esh" > "$config_dir/theme/eza-colors"

# Re-build bat cache
#-------------------------------------------------------------------------------

echo "Re-building bat cache."

bat cache --build

# Re-build 256-index cache
#-------------------------------------------------------------------------------

echo "Re-building 256-index cache."

"$opt_dir/theme/color-lookup-256-index.sh" --cache

# Configure directory colors
#-------------------------------------------------------------------------------

echo "Configuring directory colors."

source "$opt_dir/theme/configure-dircolors.sh"

# Configure GTK
#-------------------------------------------------------------------------------

echo "Configuring GTK."

source "$opt_dir/theme/configure-gtk.sh"
