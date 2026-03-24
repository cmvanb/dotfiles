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
% if 'workstation' in DEPLOY_PROFILE.split():
% if DEPLOY_DISTRO == 'ubuntu':

set -x BROWSER "chromium"
% else:

set -x BROWSER "qutebrowser"
% endif

set -x LAUNCHER "fuzzel"
set -x TERMINAL "alacritty"
% endif

set -x EDITOR "nvim"

# Configure less pager.
set -x LESS "--clear-screen --RAW-CONTROL-CHARS --tilde +25d"
