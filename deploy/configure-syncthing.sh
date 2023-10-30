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

echo "#include .stignore_synced" > "$HOME/Documents/.stignore"
echo "#include .stignore_synced" > "$HOME/Media/.stignore"
echo "#include .stignore_synced" > "$HOME/Projects/.stignore"
echo "#include .stignore_synced" > "$HOME/Wiki/.stignore"
echo "#include .stignore_synced" > "$config_dir/qutebrowser/.stignore"
echo "#include .stignore_synced" > "$data_dir/qutebrowser/sessions/.stignore"
