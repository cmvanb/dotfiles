#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy desktop shell scripts
#-------------------------------------------------------------------------------

echo "Deploying desktop shell scripts..."

scripts_dir=${XDG_SCRIPTS_HOME:-$HOME/.local/scripts}

# TODO: Move to theme module.
mkdir -p "$scripts_dir"
force_link "$base_dir/local/scripts/generate-color-gradient-palette.py" "$scripts_dir/generate-color-gradient-palette.py"
