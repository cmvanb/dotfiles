#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy the theme configuration
#-------------------------------------------------------------------------------

set -euo pipefail

bash_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
source_dir=$(realpath "$bash_dir/..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
opt_dir=${XDG_OPT_HOME:-$HOME/.local/opt}

# Imports
#-------------------------------------------------------------------------------

source "$source_dir/.local/scripts/fs-utils.sh"

# Install system theme scripts
#-------------------------------------------------------------------------------

# TODO: Move all theme API scripts to `.local/opt/theme`.

mkdir -p "$opt_dir/theme"
force_link "$source_dir/.config/theme/theme.fish" "$opt_dir/theme/theme.fish"
force_link "$source_dir/.config/theme/theme.lua" "$opt_dir/theme/theme.lua"
force_link "$source_dir/.config/theme/theme.py" "$opt_dir/theme/theme.py"
force_link "$source_dir/.config/theme/theme.sh" "$opt_dir/theme/theme.sh"
force_link "$source_dir/.config/theme/color-hex-to-ansi.sh" "$opt_dir/theme/color-hex-to-ansi.sh"
force_link "$source_dir/.config/theme/color-index-to-ansi.sh" "$opt_dir/theme/color-index-to-ansi.sh"
force_link "$source_dir/.config/theme/color-lookup-256-index.sh" "$opt_dir/theme/color-lookup-256-index.sh"
force_link "$source_dir/.config/theme/configure-dircolors.sh" "$opt_dir/theme/configure-dircolors.sh"
force_link "$source_dir/.config/theme/configure-dircolors.fish" "$opt_dir/theme/configure-dircolors.fish"

# Select system theme
#-------------------------------------------------------------------------------

echo "Linking selected theme colors."

force_link "$config_dir/theme/carbon-dark" "$config_dir/theme/colors"

# Generate theme templates
#-------------------------------------------------------------------------------

echo "Generating theme templates."

mkdir -p "$config_dir/bat/themes"
esh "$source_dir/.config/theme/carbon-dark.tmTheme~esh" > "$config_dir/bat/themes/carbon-dark.tmTheme"

mkdir -p "$config_dir/theme"
esh "$source_dir/.config/theme/dircolors-256~esh" > "$config_dir/theme/dircolors-256"
esh "$source_dir/.config/theme/eza-colors~esh" > "$config_dir/theme/eza-colors"

# Re-build bat cache
#-------------------------------------------------------------------------------

echo "Re-building bat cache."

/usr/bin/bat cache --build

# Configure directory colors
#-------------------------------------------------------------------------------

echo "Configuring directory colors."

source "$opt_dir/theme/configure-dircolors.sh"

# Configure GTK
#-------------------------------------------------------------------------------

echo "Configuring GTK."

source "$source_dir/.config/theme/configure-gtk.sh"
