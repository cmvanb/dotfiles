#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Bash interactive configuration
#-------------------------------------------------------------------------------

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# General configuration
#-------------------------------------------------------------------------------

# Save bash history in an XDG compliant directory.
export HISTFILE="$XDG_DATA_HOME/bash/history"

# Save python history in an XDG compliant directory.
export PYTHON_HISTORY="$XDG_DATA_HOME/python/history"
# <% if [[ " $DEPLOY_PROFILE " == *" workstation "* ]]; then -%>

# Functions
#-------------------------------------------------------------------------------

# Logout of the current session.
# NOTE: We don't use the shell's builtin logout command.
function logout () {
    "$XDG_BIN_HOME/logout"
}

# Suspend the system.
# NOTE: We don't use the shell's builtin suspend command.
function suspend () {
    "$XDG_BIN_HOME/suspend"
}

# <% fi -%>

# Aliases
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_CONFIG_HOME/bash/shared_aliases.sh"

# shellcheck disable=SC1091
source "$XDG_CONFIG_HOME/bash/deployed_aliases.sh"


# Bindings
#-------------------------------------------------------------------------------

# Unbindings
bind -r '\C-b'
bind -r '\C-h'
bind -r '\C-j'
bind -r '\C-k'
bind -r '\C-l'
bind -r '\C-p'

# Open editor
bind -x '"\C-e":"edit"'

# Open file browser
bind -x '"\C-f":"yzcd"'

# List all files
bind -x '"\C-u":"clear; eza -al | view.sh"'

# List all files in tree format
# NOTE: Ctrl+I is normally interpreted as Tab, but we want to use it here, so
# we rebind it to simulate F13 (\e\[1\;2P).
bind -x '"\e\[1\;2P":"clear; eza -aT --git-ignore | view.sh"'

# # Copy the whole line to clipboard
copy_line_to_clipboard () {
    printf %s "$READLINE_LINE" | wl-copy
}
bind -x '"\ec": copy_line_to_clipboard'

# Clear screen
bind -x '"\C-y":"clear"'

# Theme
#-------------------------------------------------------------------------------

# Configure directory colors (ls, eza, lf).
eval "$(dircolors --bourne-shell "$XDG_CONFIG_HOME/theme/dircolors")"
EZA_COLORS="$(tr -d '\n' < "$XDG_CONFIG_HOME/theme/eza-colors")$LS_COLORS"
export EZA_COLORS

# Prompt
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_CONFIG_HOME/bash/prompt.sh"

# Integrations
#-------------------------------------------------------------------------------

# Enable direnv.
eval "$(direnv hook bash)"

# Enable Zoxide.
eval "$(zoxide init bash)"

# LF CD integration.
source "$XDG_CONFIG_HOME/lf/lfcd.sh"

# Yazi integration.
source "$XDG_CONFIG_HOME/yazi/yzcd.sh"
