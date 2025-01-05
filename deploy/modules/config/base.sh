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

# Fish
mkdir -p "$config_dir/fish"
force_link "$base_dir/config/fish/config.fish" "$config_dir/fish/config.fish"
esh "$base_dir/config/fish/env.fish~esh" > "$config_dir/fish/env.fish"
esh "$base_dir/config/fish/interactive.fish~esh" > "$config_dir/fish/interactive.fish"
esh "$base_dir/config/fish/login.fish~esh" > "$config_dir/fish/login.fish"
force_link "$base_dir/config/fish/logout.fish" "$config_dir/fish/logout.fish"
force_link "$base_dir/config/fish/functions" "$config_dir/fish/functions"

# Git
force_link "$base_dir/config/git" "$config_dir/git"

# Neovim
force_link "$base_dir/config/nvim" "$config_dir/nvim"

# NPM
force_link "$base_dir/config/npm" "$config_dir/npm"

# Readline
force_link "$base_dir/config/readline" "$config_dir/readline"

# Ripgrep
mkdir -p "$config_dir/ripgrep"
esh "$base_dir/config/ripgrep/config~esh" > "$config_dir/ripgrep/config"

# Shell
force_link "$base_dir/config/shell" "$config_dir/shell"

# Wget
mkdir -p "$config_dir/wget"
esh "$base_dir/config/wget/wgetrc~esh" > "$config_dir/wget/wgetrc"
