#-------------------------------------------------------------------------------
# Fish environment configuration
#-------------------------------------------------------------------------------

# No write permissions for group or others.
umask 0022

# Environment
#-------------------------------------------------------------------------------

# Tell Bash how to configure its environment (for *non-interactive* shells).
set -x BASH_ENV $HOME/.config/bash/env

# Some programs respect these defaults, others are supported by XDG with
# configuration in `.config/mimeapps.list` and `.local/share/applications/`.
set -x BROWSER "qutebrowser"
set -x EDITOR "nvim"

# Configure less pager.
set -x LESS "--clear-screen --RAW-CONTROL-CHARS"

# Quiet direnv.
set -x DIRENV_LOG_FORMAT ""

# Integrations
#-------------------------------------------------------------------------------

# Enable direnv.
direnv hook fish | source

# Enable Zoxide
zoxide init fish | source
