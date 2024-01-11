#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Configure Syncthing
#-------------------------------------------------------------------------------

set -euo pipefail

config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
data_dir=${XDG_DATA_HOME:-$HOME/.local/share}

# Generate syncthing ignore files.
#-------------------------------------------------------------------------------

echo "Configuring Syncthing."

mkdir -p "$HOME/Documents"
echo "#include .stignore_synced" > "$HOME/Documents/.stignore"

mkdir -p "$HOME/Media"
echo "#include .stignore_synced" > "$HOME/Media/.stignore"

mkdir -p "$HOME/Projects"
echo "#include .stignore_synced" > "$HOME/Projects/.stignore"

mkdir -p "$HOME/Wiki"
echo "#include .stignore_synced" > "$HOME/Wiki/.stignore"

mkdir -p "$config_dir/qutebrowser"
echo "#include .stignore_synced" > "$config_dir/qutebrowser/.stignore"

mkdir -p "$data_dir/qutebrowser/sessions"
echo "#include .stignore_synced" > "$data_dir/qutebrowser/sessions/.stignore"
