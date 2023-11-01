#-------------------------------------------------------------------------------
# Fish environment configuration
#-------------------------------------------------------------------------------

# Tell Bash how to configure its environment (for *non-interactive* shells).
set -x BASH_ENV $HOME/.config/bash/env

# No write permissions for group or others.
umask 0022

# Some programs respect these defaults, others are supported by XDG with
# configuration in `.config/mimeapps.list` and `.local/share/applications/`.
set -x BROWSER "qutebrowser"
set -x EDITOR "nvim"
set -x VISUAL "$EDITOR"

# Configure less pager.
set -x LESS "-c -R"
