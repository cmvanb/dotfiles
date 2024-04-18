#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Bash environment configuration
#-------------------------------------------------------------------------------

# Tell Bash how to configure its environment (for *non-interactive* shells).
export BASH_ENV="~/.config/bash/env"

# No write permissions for group or others.
umask 0022

# Some programs respect these defaults, others are supported by XDG with
# configuration in `.config/mimeapps.list` and `.local/share/applications/`.
export BROWSER="qutebrowser"
export EDITOR="nvim"
export VISUAL="$EDITOR"

# Configure less pager.
export LESS="--clear-screen --RAW-CONTROL-CHARS"

# Enable direnv.
eval "$(direnv hook bash)"
