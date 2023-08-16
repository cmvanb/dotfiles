#-------------------------------------------------------------------------------
# Fish environment configuration
#
# This should work exactly the same as ~/.config/shell/generic/env.
# Unfortunately, it's not trivial to source a POSIX shell script from fish, so
# the functionality is duplicated here.
#
# NOTE: Although `bass` works, it degrades performance to an unacceptable level.
#   `bass 'source /home/casper/.config/shell/generic/env'`
#-------------------------------------------------------------------------------

# We need to set $ENV so that if you use shell X as your login shell, and then
# start "sh" as a non-login interactive shell the startup scripts will
# correctly run.
set -x ENV $HOME/.config/shell/sh/interactive

# We also need to set BASH_ENV, which is run for *non-interactive* shells.
# (unlike $ENV, which is for interactive shells)
set -x BASH_ENV $HOME/.config/shell/bash/env

# No write permissions for group or others.
umask 0022

# Some programs respect these defaults, others are supported by XDG with
# configuration in `.config/mimeapps.list` and `.local/share/applications/`.
set -x BROWSER "qutebrowser"
set -x EDITOR "nvim"
set -x VISUAL "$EDITOR"

# Configure ls/exa.
set -x LS_COLORS "no=37:fi=37:di=34;1:ln=33:or=31:mi=31:ex=32;1:*.pdf=37:*.zip=37"

# Configure less pager.
set -x LESS "-c -R"

