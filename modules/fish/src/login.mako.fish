#-------------------------------------------------------------------------------
# Fish login configuration
#-------------------------------------------------------------------------------

# Environment
#-------------------------------------------------------------------------------

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

% if 'workstation' in DEPLOY_PROFILE.split():

# XDG user directories.
set -x XDG_DOCUMENTS_DIR $HOME/Documents
set -x XDG_DOWNLOAD_DIR $HOME/Downloads
set -x XDG_MUSIC_DIR $HOME/Media/Music
set -x XDG_PICTURES_DIR $HOME/Media/Images
set -x XDG_TEMPLATES_DIR $XDG_DATA_HOME/templates
set -x XDG_VIDEOS_DIR $HOME/Media/Videos

# Custom directories.
set -x XDG_CODE_DIR $HOME/Code
set -x XDG_WIKI_DIR $HOME/Wiki

# SSH agent integration.
set -x SSH_AUTH_SOCK $XDG_RUNTIME_DIR/gcr/ssh

# Pyenv installation.
set -x PYENV_ROOT $XDG_OPT_HOME/pyenv

# Claude config.
set -x CLAUDE_CONFIG_DIR $XDG_CONFIG_HOME/claude

# Docker config.
set -x DOCKER_CONFIG $XDG_STATE_HOME/docker

# GNUPG config.
set -x GNUPGHOME $XDG_STATE_HOME/gnupg

# Rust config.
set -x CARGO_HOME $XDG_DATA_HOME/cargo
set -x RUSTUP_HOME $XDG_DATA_HOME/rustup

# Pi coding agent config.
set -x PI_CONFIG_DIR $XDG_CONFIG_HOME/pi
set -x PI_CODING_AGENT_DIR $XDG_CONFIG_HOME/pi

# VSCode config.
set -x VSCODE_PORTABLE $XDG_DATA_HOME/vscode

% endif

# NPM config.
set -x NPM_CONFIG_USERCONFIG $XDG_CONFIG_HOME/npm/npmrc

# Python config.
set -x PYTHONPYCACHEPREFIX $XDG_CACHE_HOME/python

# Readline config.
set -x INPUTRC $XDG_CONFIG_HOME/readline/inputrc

# Wget config.
set -x WGETRC $XDG_CONFIG_HOME/wget/wgetrc

# Ansible config.
set -x ANSIBLE_HOME $XDG_CONFIG_HOME/ansible
set -x ANSIBLE_CONFIG $XDG_CONFIG_HOME/ansible.cfg
set -x ANSIBLE_GALAXY_CACHE_DIR $XDG_CACHE_HOME/ansible/galaxy_cache
set -x ANSIBLE_LOCAL_TEMP $XDG_CACHE_HOME/ansible/tmp
set -x ANSIBLE_REMOTE_TEMP $XDG_CACHE_HOME/ansible/tmp
set -x ANSIBLE_SSH_CONTROL_PATH_DIR $XDG_CACHE_HOME/ansible/cp
set -x ANSIBLE_ASYNC_DIR $XDG_CACHE_HOME/ansible_async

# Terminal support
#-------------------------------------------------------------------------------

# 24bit color support
if test "$TERM" = "alacritty"
or test "$TERM" = "xterm-256color"
or test "$TERM" = "xterm-ghostty"
    set -x COLORTERM truecolor
end

# Virtual terminal theme
if test "$TERM" = "linux"
    $XDG_CONFIG_HOME/vt/apply-vt-colors.sh | systemd-cat -t fish-login
end

% if 'workstation' in DEPLOY_PROFILE.split():
# Ensure user directories exist
#-------------------------------------------------------------------------------

mkdir -p $XDG_DOCUMENTS_DIR $XDG_DOWNLOAD_DIR $XDG_MUSIC_DIR $XDG_PICTURES_DIR $XDG_VIDEOS_DIR

% endif
# Path
#-------------------------------------------------------------------------------

# Add user executables to path.
fish_add_path -pP $XDG_BIN_HOME
fish_add_path -pP $XDG_SCRIPTS_HOME

% if 'workstation' in DEPLOY_PROFILE.split():
# Add user rust binaries to path.
fish_add_path -pP $XDG_DATA_HOME/cargo/bin

% endif
# Clean home directory
#-------------------------------------------------------------------------------

$XDG_SCRIPTS_HOME/clean-home.sh &>/dev/null &
