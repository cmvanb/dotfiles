#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy base shell scripts
#-------------------------------------------------------------------------------

echo "Deploying base shell scripts..."

scripts_dir=${XDG_SCRIPTS_HOME:-$HOME/.local/scripts}

mkdir -p "$scripts_dir"
force_link "$base_dir/.local/scripts/clean-home.sh" "$scripts_dir/clean-home.sh"
force_link "$base_dir/.local/scripts/estimate-disk-space-usage.sh" "$scripts_dir/estimate-disk-space-usage.sh"
force_link "$base_dir/.local/scripts/format-text.sh" "$scripts_dir/format-text.sh"
force_link "$base_dir/.local/scripts/generate-venv.sh" "$scripts_dir/generate-venv.sh"
force_link "$base_dir/.local/scripts/kebabify.sh" "$scripts_dir/kebabify.sh"
force_link "$base_dir/.local/scripts/print-environment.py" "$scripts_dir/print-environment.py"
force_link "$base_dir/.local/scripts/print-terminal-colors.sh" "$scripts_dir/print-terminal-colors.sh"
force_link "$base_dir/.local/scripts/rename-kebabcase.sh" "$scripts_dir/rename-kebabcase.sh"
force_link "$base_dir/.local/scripts/set-terminal-title.sh" "$scripts_dir/set-terminal-title.sh"
force_link "$base_dir/.local/scripts/show-path.sh" "$scripts_dir/show-path.sh"
force_link "$base_dir/.local/scripts/terminal-preview.sh" "$scripts_dir/terminal-preview.sh"
force_link "$base_dir/.local/scripts/view.sh" "$scripts_dir/view.sh"
