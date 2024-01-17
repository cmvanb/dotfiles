#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Bash login configuration
#-------------------------------------------------------------------------------

# Environment
#-------------------------------------------------------------------------------

# SSH agent integration.
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.sock"

# XDG base directories.
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.local/cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Custom directories.
export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_OPT_HOME="$HOME/.local/opt"
export XDG_SCRIPTS_HOME="$HOME/.local/scripts"
export XDG_SECRETS_HOME="$HOME/.local/secrets"

# XDG user directories.
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_MUSIC_DIR="$HOME/Media/Music"
export XDG_PICTURES_DIR="$HOME/Media/Images"
export XDG_TEMPLATES_DIR="$XDG_DATA_HOME/templates"
export XDG_VIDEOS_DIR="$HOME/Media/Videos"

# NOTE: This really should be independent of the shell configuration...
# Pyenv installation.
export PYENV_ROOT="$XDG_OPT_HOME/pyenv"

# Docker config.
export DOCKER_CONFIG="$XDG_STATE_HOME/docker"

# GNUPG config.
export GNUPG_HOME="$XDG_STATE_HOME/gnupg"

# Kubernetes config.
export KUBECONFIG="$XDG_CONFIG_HOME/kube"
export KUBECACHEDIR="$XDG_CACHE_HOME/kube"

# Python config.
export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/python"
export PIP_REQUIRE_VIRTUALENV=true

# Rust config.
export CARGO_HOME="$XDG_DATA_HOME/cargo"

# Silence direnv.
export DIRENV_LOG_FORMAT=""

# User directories
#-------------------------------------------------------------------------------

mkdir -p \
    "$XDG_DOCUMENTS_DIR" \
    "$XDG_DOWNLOAD_DIR" \
    "$XDG_MUSIC_DIR" \
    "$XDG_PICTURES_DIR" \
    "$XDG_VIDEOS_DIR"

# Path
#-------------------------------------------------------------------------------

# Import path utility functions.
# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/path.sh"

# Add user binaries to path
path_prepend "$XDG_BIN_HOME" PATH
path_prepend "$XDG_SCRIPTS_HOME" PATH

# Add pyenv python shims to path
path_prepend "$PYENV_ROOT/bin" PATH

# Add user rust binaries to path.
path_prepend "$XDG_DATA_HOME/cargo/bin" PATH

# Pyenv integration
#-------------------------------------------------------------------------------

if command -v pyenv &> /dev/null; then
    eval "$(pyenv init -)"
fi
