#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy desktop shell scripts
#-------------------------------------------------------------------------------

echo "Deploying desktop shell scripts..."

scripts_dir=${XDG_SCRIPTS_HOME:-$HOME/.local/scripts}

mkdir -p "$scripts_dir"
force_link "$base_dir/.local/scripts/add-bookmark.sh" "$scripts_dir/add-bookmark.sh"
force_link "$base_dir/.local/scripts/count-command-usage.sh" "$scripts_dir/count-command-usage.sh"
force_link "$base_dir/.local/scripts/fetch-password.sh" "$scripts_dir/fetch-password.sh"
force_link "$base_dir/.local/scripts/generate-color-gradient-palette.py" "$scripts_dir/generate-color-gradient-palette.py"
force_link "$base_dir/.local/scripts/lock-screen.sh" "$scripts_dir/lock-screen.sh"
force_link "$base_dir/.local/scripts/markdown-to-html.sh" "$scripts_dir/markdown-to-html.sh"
force_link "$base_dir/.local/scripts/matrix.sh" "$scripts_dir/matrix.sh"
force_link "$base_dir/.local/scripts/open-qutebrowser-session.sh" "$scripts_dir/open-qutebrowser-session.sh"
force_link "$base_dir/.local/scripts/open-terminal-cwd.sh" "$scripts_dir/open-terminal-cwd.sh"
force_link "$base_dir/.local/scripts/preview-markdown.sh" "$scripts_dir/preview-markdown.sh"
force_link "$base_dir/.local/scripts/screenshot-rectangle.sh" "$scripts_dir/screenshot-rectangle.sh"
force_link "$base_dir/.local/scripts/select-bookmark.sh" "$scripts_dir/select-bookmark.sh"
force_link "$base_dir/.local/scripts/set-output-wallpaper.sh" "$scripts_dir/set-output-wallpaper.sh"
force_link "$base_dir/.local/scripts/show-webcam.sh" "$scripts_dir/show-webcam.sh"
