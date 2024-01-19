#-------------------------------------------------------------------------------
# Fish login configuration
#-------------------------------------------------------------------------------

# Environment
#-------------------------------------------------------------------------------

# SSH agent integration.
set -x SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.sock

# XDG base directories.
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_CACHE_HOME $HOME/.local/cache
set -x XDG_DATA_HOME $HOME/.local/share
set -x XDG_STATE_HOME $HOME/.local/state

# Custom directories.
set -x XDG_BIN_HOME $HOME/.local/bin
set -x XDG_OPT_HOME $HOME/.local/opt
set -x XDG_SCRIPTS_HOME $HOME/.local/scripts
set -x XDG_SECRETS_HOME $HOME/.local/secrets

# XDG user directories.
set -x XDG_DOCUMENTS_DIR $HOME/Documents
set -x XDG_DOWNLOAD_DIR $HOME/Downloads
set -x XDG_MUSIC_DIR $HOME/Media/Music
set -x XDG_PICTURES_DIR $HOME/Media/Images
set -x XDG_TEMPLATES_DIR $XDG_DATA_HOME/templates
set -x XDG_VIDEOS_DIR $HOME/Media/Videos

# NOTE: This really should be independent of the shell configuration...
# Pyenv installation.
set -x PYENV_ROOT $XDG_OPT_HOME/pyenv

# Docker config.
set -x DOCKER_CONFIG $XDG_STATE_HOME/docker

# GNUPG config.
set -x GNUPGHOME $XDG_STATE_HOME/gnupg

# Kubernetes config.
set -x KUBECONFIG $XDG_CONFIG_HOME/kube
set -x KUBECACHEDIR $XDG_CACHE_HOME/kube

# Python config.
set -x PYTHONPYCACHEPREFIX $XDG_CACHE_HOME/python
set -x PIP_REQUIRE_VIRTUALENV true

# Rust config.
set -x CARGO_HOME $XDG_DATA_HOME/cargo

# Silence direnv.
set -x DIRENV_LOG_FORMAT ""

# User directories
#-------------------------------------------------------------------------------

mkdir -p $XDG_DOCUMENTS_DIR $XDG_DOWNLOAD_DIR $XDG_MUSIC_DIR $XDG_PICTURES_DIR $XDG_VIDEOS_DIR

# Path
#-------------------------------------------------------------------------------

# Add user executables to path.
fish_add_path -pP $XDG_BIN_HOME
fish_add_path -pP $XDG_SCRIPTS_HOME

# Add pyenv python shims to path.
fish_add_path -pP $PYENV_ROOT/bin

# Add user rust binaries to path.
fish_add_path -pP $XDG_DATA_HOME/cargo/bin

# Pyenv integration
#-------------------------------------------------------------------------------

if command -v pyenv &> /dev/null
    pyenv init - | source
end
