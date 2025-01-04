#!/usr/bin/env fish
#-------------------------------------------------------------------------------
# Configure the directory colors (ls, eza, lf)
#-------------------------------------------------------------------------------

set config_dir $XDG_CONFIG_HOME/theme

# Configure ls colors.
eval (dircolors --c-shell $config_dir/dircolors)

# Configure eza colors.
set -x EZA_COLORS (tr -d '\n' < $config_dir/eza-colors)$LS_COLORS
