#-------------------------------------------------------------------------------
# Fish login configuration
#
# This should work exactly the same as ~/.config/shell/generic/login
# Unfortunately, it's not trivial to source a POSIX shell script from fish, so
# the functionality is duplicated here.
#
# NOTE: Although `bass` works, it degrades performance to an unacceptable level.
#   `bass 'source /home/casper/.config/shell/generic/login'`
#-------------------------------------------------------------------------------

# Environment
# Put your shell-independent, login environment variables here.
#-------------------------------------------------------------------------------

# XDG base directories>
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_CACHE_HOME $HOME/.cache
set -x XDG_DATA_HOME $HOME/.local/share
set -x XDG_STATE_HOME $HOME/.local/state

# XDG user directories.
set -x XDG_DOCUMENTS_DIR $HOME/Documents
set -x XDG_DOWNLOAD_DIR $HOME/Downloads
set -x XDG_MUSIC_DIR $HOME/Media/Music
set -x XDG_PICTURES_DIR $HOME/Media/Images
set -x XDG_VIDEOS_DIR $HOME/Media/Videos

# Provide ssh-agent socket.
set -x SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.sock

# Configure pyenv (for dynamically swapping python versions).
set -x PYENV_ROOT $HOME/.pyenv

# User directories
#-------------------------------------------------------------------------------

mkdir -p $XDG_DOCUMENTS_DIR $XDG_DOWNLOAD_DIR $XDG_MUSIC_DIR $XDG_PICTURES_DIR $XDG_VIDEOS_DIR

# Path
#-------------------------------------------------------------------------------

# Add user binaries to path.
fish_add_path -pP $HOME/.local/bin

# Add pyenv python shims to path.
fish_add_path -pP $PYENV_ROOT/bin

