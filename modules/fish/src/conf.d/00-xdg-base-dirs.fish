#-------------------------------------------------------------------------------
# XDG base directories configuration
#-------------------------------------------------------------------------------

set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_CACHE_HOME $HOME/.local/cache
set -x XDG_DATA_HOME $HOME/.local/share
set -x XDG_STATE_HOME $HOME/.local/state

# Custom directories
set -x XDG_BIN_HOME $HOME/.local/bin
set -x XDG_OPT_HOME $HOME/.local/opt
set -x XDG_SCRIPTS_HOME $HOME/.local/scripts
set -x XDG_SECRETS_HOME $HOME/.local/secrets
