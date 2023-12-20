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

source "$base_dir/.local/opt/shell-utils/fs.sh"

# Install system theme scripts
#-------------------------------------------------------------------------------

mkdir -p "$opt_dir/theme"
force_link "$base_dir/.local/opt/theme/color-hex-to-ansi.sh" "$opt_dir/theme/color-hex-to-ansi.sh"
force_link "$base_dir/.local/opt/theme/color-index-to-ansi.sh" "$opt_dir/theme/color-index-to-ansi.sh"
force_link "$base_dir/.local/opt/theme/color-lookup-256-index.sh" "$opt_dir/theme/color-lookup-256-index.sh"
force_link "$base_dir/.local/opt/theme/configure-dircolors.fish" "$opt_dir/theme/configure-dircolors.fish"
force_link "$base_dir/.local/opt/theme/configure-dircolors.sh" "$opt_dir/theme/configure-dircolors.sh"
force_link "$base_dir/.local/opt/theme/configure-gtk.sh" "$opt_dir/theme/configure-gtk.sh"
force_link "$base_dir/.local/opt/theme/theme.fish" "$opt_dir/theme/theme.fish"
force_link "$base_dir/.local/opt/theme/theme.lua" "$opt_dir/theme/theme.lua"
force_link "$base_dir/.local/opt/theme/theme.py" "$opt_dir/theme/theme.py"
force_link "$base_dir/.local/opt/theme/theme.sh" "$opt_dir/theme/theme.sh"

# Select system theme
#-------------------------------------------------------------------------------

echo "Linking selected theme colors."

force_link "$config_dir/theme/carbon-dark" "$config_dir/theme/colors"

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

/usr/bin/bat cache --build

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
