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

# Configure ls/eza.
set -x LS_COLORS "no=37:fi=37:di=34;1:ln=33:or=31:mi=31:ex=32;1:*.pdf=37:*.zip=37"

# Configure less pager.
set -x LESS "-c -R"
