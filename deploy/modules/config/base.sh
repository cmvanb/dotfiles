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
mkdir -p "$config_dir/bash"
force_link "$base_dir/.config/bash/bash_profile" "$config_dir/bash/bash_profile"
force_link "$base_dir/.config/bash/bashrc" "$config_dir/bash/bashrc"
esh "$base_dir/.config/bash/env.sh~esh" > "$config_dir/bash/env.sh"
esh "$base_dir/.config/bash/interactive.sh~esh" > "$config_dir/bash/interactive.sh"
esh "$base_dir/.config/bash/login.sh~esh" > "$config_dir/bash/login.sh"
force_link "$base_dir/.config/bash/logout.sh" "$config_dir/bash/logout.sh"
force_link "$base_dir/.config/bash/prompt.sh" "$config_dir/bash/prompt.sh"

# Bat
mkdir -p "$config_dir/bat"
force_link "$base_dir/.config/bat/config" "$config_dir/bat/config"
force_link "$base_dir/.config/bat/syntaxes" "$config_dir/bat/syntaxes"

# Broot
mkdir -p "$config_dir/broot"
force_link "$base_dir/.config/broot/brcd.sh" "$config_dir/broot/brcd.sh"
force_link "$base_dir/.config/broot/brcd.fish" "$config_dir/broot/brcd.fish"
force_link "$base_dir/.config/broot/conf.hjson" "$config_dir/broot/conf.hjson"
force_link "$base_dir/.config/broot/verbs.hjson" "$config_dir/broot/verbs.hjson"
mkdir -p "$config_dir/broot/skins"
esh "$base_dir/.config/broot/skins/carbon-dark.hjson~esh" > "$config_dir/broot/skins/carbon-dark.hjson"

# Fish
mkdir -p "$config_dir/fish"
force_link "$base_dir/.config/fish/config.fish" "$config_dir/fish/config.fish"
esh "$base_dir/.config/fish/env.fish~esh" > "$config_dir/fish/env.fish"
esh "$base_dir/.config/fish/interactive.fish~esh" > "$config_dir/fish/interactive.fish"
esh "$base_dir/.config/fish/login.fish~esh" > "$config_dir/fish/login.fish"
force_link "$base_dir/.config/fish/logout.fish" "$config_dir/fish/logout.fish"
force_link "$base_dir/.config/fish/functions" "$config_dir/fish/functions"

# Git
force_link "$base_dir/.config/git" "$config_dir/git"

# Lf
force_link "$base_dir/.config/lf" "$config_dir/lf"

# Neovim
force_link "$base_dir/.config/nvim" "$config_dir/nvim"

# NPM
force_link "$base_dir/.config/npm" "$config_dir/npm"

# Readline
force_link "$base_dir/.config/readline" "$config_dir/readline"

# Ripgrep
mkdir -p "$config_dir/ripgrep"
esh "$base_dir/.config/ripgrep/config~esh" > "$config_dir/ripgrep/config"

# Shell
force_link "$base_dir/.config/shell" "$config_dir/shell"

# Wget
mkdir -p "$config_dir/wget"
esh "$base_dir/.config/wget/wgetrc~esh" > "$config_dir/wget/wgetrc"
