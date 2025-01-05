#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy base configuration files
#-------------------------------------------------------------------------------

echo "Deploying base configuration files..."

# Setup
#-------------------------------------------------------------------------------

config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

# Link configuration
#-------------------------------------------------------------------------------

# Shell
force_link "$base_dir/config/shell" "$config_dir/shell"

# Wget
mkdir -p "$config_dir/wget"
esh "$base_dir/config/wget/wgetrc~esh" > "$config_dir/wget/wgetrc"
