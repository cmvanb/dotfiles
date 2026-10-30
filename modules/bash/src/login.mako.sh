#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Bash login configuration
#-------------------------------------------------------------------------------

# Source modular login configuration.
#-------------------------------------------------------------------------------

for f in "$HOME/.config/bash/conf.d/"*.sh; do
    [[ -f "$f" ]] && source "$f"
done

# Environment
#-------------------------------------------------------------------------------

% if 'workstation' in DEPLOY_PROFILE.split():

# XDG user directories.
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_MUSIC_DIR="$HOME/Media/Music"
export XDG_PICTURES_DIR="$HOME/Media/Images"
export XDG_TEMPLATES_DIR="$XDG_DATA_HOME/templates"
export XDG_VIDEOS_DIR="$HOME/Media/Videos"

# Custom directories.
export XDG_CODE_DIR="$HOME/Code"
export XDG_WIKI_DIR="$HOME/Wiki"

# SSH agent integration.
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
% endif

# Readline config.
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"

# Terminal support
#-------------------------------------------------------------------------------

# 24bit color support
if [[ $TERM == "alacritty" ]] \
|| [[ $TERM == "xterm-256color" ]]; then
    export COLORTERM truecolor
fi

# Virtual terminal theme
if [[ $TERM == "linux" ]]; then
    "$XDG_CONFIG_HOME/vt/apply-vt-colors.sh" | systemd-cat -t bash-login
fi

% if 'workstation' in DEPLOY_PROFILE.split():

# Ensure user directories exist
#-------------------------------------------------------------------------------

mkdir -p "$XDG_DOCUMENTS_DIR" "$XDG_DOWNLOAD_DIR" "$XDG_MUSIC_DIR" "$XDG_PICTURES_DIR" "$XDG_VIDEOS_DIR"
% endif

# Clean home directory
#-------------------------------------------------------------------------------

"$XDG_SCRIPTS_HOME/clean-home.sh" &>/dev/null &
