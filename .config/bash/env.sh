#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Bash environment configuration
#-------------------------------------------------------------------------------

# No write permissions for group or others.
umask 0022

# Environment
#-------------------------------------------------------------------------------

# Tell Bash how to configure its environment (for *non-interactive* shells).
export BASH_ENV="~/.config/bash/env"

# Some programs respect these defaults, others are supported by XDG with
# configuration in `.config/mimeapps.list` and `.local/share/applications/`.
export BROWSER="qutebrowser"
export EDITOR="nvim"

# Configure less pager.
export LESS="--clear-screen --RAW-CONTROL-CHARS"

# Quiet direnv.
export DIRENV_LOG_FORMAT=""

# Integrations
#-------------------------------------------------------------------------------

# Enable direnv.
eval "$(direnv hook bash)"

# Enable Zoxide.
eval "$(zoxide init bash)"
