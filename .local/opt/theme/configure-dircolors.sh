#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Configure the directory colors (ls, eza, lf)
#-------------------------------------------------------------------------------

config_dir="$XDG_CONFIG_HOME/theme"

# Configure ls colors.
eval "$(dircolors --bourne-shell "$config_dir/dircolors")"

# Configure eza colors.
export EZA_COLORS="$(tr -d '\n' < "$config_dir/eza-colors")$LS_COLORS"
