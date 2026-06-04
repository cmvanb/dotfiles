#-------------------------------------------------------------------------------
# Fish login configuration
#-------------------------------------------------------------------------------

# Environment
#-------------------------------------------------------------------------------

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

% endif

# Readline config.
set -x INPUTRC $XDG_CONFIG_HOME/readline/inputrc

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

# Clean home directory
#-------------------------------------------------------------------------------

$XDG_SCRIPTS_HOME/clean-home.sh &>/dev/null &
