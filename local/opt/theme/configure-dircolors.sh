#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Configure the directory colors (ls, eza, lf)
#-------------------------------------------------------------------------------

theme_config_dir="$XDG_CONFIG_HOME/theme"

# Configure ls colors.
eval "$(dircolors --bourne-shell "$theme_config_dir/dircolors")"

# Configure eza colors.
EZA_COLORS="$(tr -d '\n' < "$theme_config_dir/eza-colors")$LS_COLORS"
export EZA_COLORS
