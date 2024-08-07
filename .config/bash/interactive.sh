#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Bash interactive configuration
#-------------------------------------------------------------------------------

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# Imports
#-------------------------------------------------------------------------------

# Generic interactive shell configuration.
# shellcheck disable=SC1091
source "$XDG_CONFIG_HOME/shell/interactive"

# Linux distribution specific shell configuration.
# shellcheck disable=SC1091
source "$XDG_CONFIG_HOME/bash/interactive-distro.sh"

# General configuration
#-------------------------------------------------------------------------------

# Save history in an XDG compliant directory.
[[ ! -d "$XDG_DATA_HOME/bash" ]] && mkdir -p "$XDG_DATA_HOME/bash"
export HISTFILE="$XDG_DATA_HOME/bash/bash_history"

# GNU readline configuration.
export INPUTRC="$XDG_CONFIG_HOME/readline/config"

# Python interactive configuration.
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/interactive.py"

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

# Aliases
#-------------------------------------------------------------------------------

alias eza="eza -l --color=always --group-directories-first --time-style=long-iso"
alias bat="bat --force-colorization --no-paging --style=grid,numbers"

alias ga="git add"
alias gaa="git add -A"
alias gai="git add -i"
alias gb="git branch -v"
alias gc="git commit -m"
alias gca="git commit --amend"
alias gco="git checkout"
alias gd="git diff"
alias gds="git diff --staged"
alias gl="git log --pretty=history"
alias gp="git push"
alias gpa="git push --all"
alias gpf="git push --force"
alias gpu="git pull --rebase"
alias gr="git remote -v"
alias grb="git rebase -i"
alias grc="git rm --cached"
alias gs="git status"
alias gsu="git status -u"
alias gsw="git switch"
alias e="edit"
alias ed="edit"
alias edi="edit"
alias ez="eza"
alias lf="lfcd"
alias ls="eza"
alias lsa="eza -a"
alias lsd="eza -a"
alias lsi="eza --git-ignore"
alias lst="eza -T --git-ignore"
alias lsta="eza -aT --git-ignore"
alias ip="ip -c"
alias vv="generate-venv.sh"
alias va="source venv/bin/activate"
alias vd="deactivate"
alias uu="sudo pacman -Syu"
alias rga="rg --hidden --no-ignore"
alias rb="reboot"
alias sus="suspend"
alias sdn="shutdown"

# Bindings
#-------------------------------------------------------------------------------

# Unbindings
bind -r '\C-b'
bind -r '\C-h'
bind -r '\C-p'

# Open editor
bind '"\C-e":"edit\C-m"'

# Open file browser
bind '"\C-f":"lfcd\C-m"'

# List all files
bind '"\C-y":"clear\C-m eza -al | view.sh \C-m"'

# List all files in tree format (NOTE: output is often long)
bind '"\e\[1\;2P":"clear\C-m eza -aT --git-ignore | view.sh\C-m"'

# LF CD integration
#-------------------------------------------------------------------------------

LFCD="$XDG_CONFIG_HOME/lf/lfcd.sh"
if [[ -f "$LFCD" ]]; then
    # shellcheck disable=SC1090
    source "$LFCD"
fi

# Theme
#-------------------------------------------------------------------------------

# Configure directory colors (ls, eza, lf).
# shellcheck disable=SC1091
source "$XDG_OPT_HOME/theme/configure-dircolors.sh"

# Prompt
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_CONFIG_HOME/bash/prompt.sh"
