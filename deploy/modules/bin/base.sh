#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy base binary shortcuts
#-------------------------------------------------------------------------------

echo "Deploying base binary shortcuts..."

bin_dir=${XDG_BIN_HOME:-$HOME/.local/bin}

echo "└> Linking binary shortcuts."
mkdir -p "$bin_dir"
force_link "$base_dir/local/bin/edit" "$bin_dir/edit"
force_link "$base_dir/local/bin/kebab" "$bin_dir/kebab"
force_link "$base_dir/local/bin/kebabify" "$bin_dir/kebabify"
force_link "$base_dir/local/bin/printenv" "$bin_dir/printenv"
force_link "$base_dir/local/bin/view" "$bin_dir/view"
force_link "$base_dir/local/bin/rg" "$bin_dir/rg"
