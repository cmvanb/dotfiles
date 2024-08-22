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

# Less
mkdir -p "$config_dir"
force_link "$base_dir/.config/lesskey" "$config_dir/lesskey"

# Bash
# TODO: Profile specific configuration of bash.
mkdir -p "$config_dir/bash"
force_link "$base_dir/.config/bash/bash_profile" "$config_dir/bash/bash_profile"
force_link "$base_dir/.config/bash/bashrc" "$config_dir/bash/bashrc"
force_link "$base_dir/.config/bash/env.sh" "$config_dir/bash/env.sh"
force_link "$base_dir/.config/bash/interactive.sh" "$config_dir/bash/interactive.sh"
force_link "$base_dir/.config/bash/login.sh" "$config_dir/bash/login.sh"
force_link "$base_dir/.config/bash/logout.sh" "$config_dir/bash/logout.sh"
force_link "$base_dir/.config/bash/prompt.sh" "$config_dir/bash/prompt.sh"

# Bat
mkdir -p "$config_dir/bat"
force_link "$base_dir/.config/bat/config" "$config_dir/bat/config"
force_link "$base_dir/.config/bat/syntaxes" "$config_dir/bat/syntaxes"

# Fish
# TODO: Profile specific configuration of fish.
mkdir -p "$config_dir/fish"
force_link "$base_dir/.config/fish/config.fish" "$config_dir/fish/config.fish"
force_link "$base_dir/.config/fish/env.fish" "$config_dir/fish/env.fish"
force_link "$base_dir/.config/fish/interactive.fish" "$config_dir/fish/interactive.fish"
force_link "$base_dir/.config/fish/login.fish" "$config_dir/fish/login.fish"
force_link "$base_dir/.config/fish/logout.fish" "$config_dir/fish/logout.fish"
force_link "$base_dir/.config/fish/functions" "$config_dir/fish/functions"

# Git
force_link "$base_dir/.config/git" "$config_dir/git"

# Lf
force_link "$base_dir/.config/lf" "$config_dir/lf"

# Neovim
force_link "$base_dir/.config/nvim" "$config_dir/nvim"

# Ripgrep
force_link "$base_dir/.config/ripgrep" "$config_dir/ripgrep"

# Shell
force_link "$base_dir/.config/shell" "$config_dir/shell"
