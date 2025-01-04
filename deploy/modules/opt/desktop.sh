#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy desktop shell libraries
#-------------------------------------------------------------------------------

echo "Deploying desktop shell libraries..."

opt_dir=${XDG_OPT_HOME:-$HOME/.local/opt}

mkdir -p "$opt_dir"
force_link "$base_dir/local/opt/wayland-utils" "$opt_dir/wayland-utils"
