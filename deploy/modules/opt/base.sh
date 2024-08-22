#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy base shell libraries
#-------------------------------------------------------------------------------

echo "Deploying base shell libraries..."

opt_dir=${XDG_OPT_HOME:-$HOME/.local/opt}

mkdir -p "$opt_dir"
force_link "$base_dir/.local/opt/shell-utils" "$opt_dir/shell-utils"
force_link "$base_dir/.local/opt/theme" "$opt_dir/theme"
