#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy base theme configuration
#-------------------------------------------------------------------------------

echo "Deploying base theme configuration..."

# Setup
#-------------------------------------------------------------------------------

config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
opt_dir=${XDG_OPT_HOME:-$HOME/.local/opt}

source "$base_dir/.local/opt/shell-utils/debug.sh"
source "$base_dir/.local/opt/shell-utils/fs.sh"

assert_dependency bat

# Install theme colors
#-------------------------------------------------------------------------------

echo "└> Installing theme colors."
mkdir -p "$config_dir/theme"
force_link "$base_dir/.config/theme/carbon-dark" "$config_dir/theme/carbon-dark"
force_link "$base_dir/.config/theme/carbon-light" "$config_dir/theme/carbon-light"

# Link selected theme colors
#-------------------------------------------------------------------------------

echo "└> Linking selected theme colors."
force_link "$config_dir/theme/carbon-dark" "$config_dir/theme/colors"

# Generate theme templates
#-------------------------------------------------------------------------------

echo "└> Generating bat theme."
mkdir -p "$config_dir/bat/themes"
esh "$base_dir/.config/theme/carbon-dark.tmTheme~esh" > "$config_dir/bat/themes/carbon-dark.tmTheme"

echo "└> Generating ls/eza theme."
mkdir -p "$config_dir/theme"
esh "$base_dir/.config/theme/dircolors~esh" > "$config_dir/theme/dircolors"
esh "$base_dir/.config/theme/eza-colors~esh" > "$config_dir/theme/eza-colors"

# Re-build caches
#-------------------------------------------------------------------------------

echo "└> Re-building bat cache."
bat cache --build

echo "└> Re-building 256-index cache."
"$opt_dir/theme/color-lookup-256-index.sh" --cache

# Configure directory colors
#-------------------------------------------------------------------------------

echo "└> Configuring ls/eza directory colors."
source "$opt_dir/theme/configure-dircolors.sh"
