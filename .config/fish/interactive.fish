#-------------------------------------------------------------------------------
# Fish interactive configuration
#-------------------------------------------------------------------------------

# Imports
#-------------------------------------------------------------------------------

# Generic interactive shell configuration.
source $XDG_CONFIG_HOME/shell/interactive

# Linux distribution specific shell configuration.
# shellcheck disable=SC1091
source "$XDG_CONFIG_HOME/fish/interactive-distro.fish"

# General configuration
#-------------------------------------------------------------------------------

# Python interactive configuration.
set -x PYTHONSTARTUP $XDG_CONFIG_HOME/python/interactive.py

# Aliases & Abbreviations
#-------------------------------------------------------------------------------

alias eza "eza -l --color=always --group-directories-first --time-style=long-iso"
alias bat "bat --force-colorization --no-paging --style=grid,numbers"

abbr -a gs git status
abbr -a gsu git status -u
abbr -a gl git log --pretty=history
abbr -a gd git diff
abbr -a gds git diff --staged
abbr -a ga git add
abbr -a gaa git add -A
abbr -a gai git add -i
abbr -a gb git branch -v
abbr -a gc git commit -m
abbr -a gca git commit --amend
abbr -a gco git checkout
abbr -a gp git push
abbr -a gpf git push --force
abbr -a grb git rebase -i
abbr -a grc git rm --cached
abbr -a grv git remote -v
abbr -a e edit
abbr -a ed edit
abbr -a edi edit
abbr -a ez eza
abbr -a ex eza
abbr -a exa eza
abbr -a lf lfcd
abbr -a ls eza
abbr -a lsa eza -a
abbr -a lsd eza -a
abbr -a lsi eza --git-ignore
abbr -a lst eza -T --git-ignore
abbr -a lsta eza -aT --git-ignore
abbr -a ip ip -c
abbr -a vv generate-venv.sh
abbr -a va source venv/bin/activate.fish
abbr -a vd deactivate

# Bindings
#-------------------------------------------------------------------------------

# Unbindings
bind \cb ''
bind \ch ''

# Open file browser
bind \cf 'lfcd; commandline -f repaint'

# Open editor
bind \ce 'edit; commandline -f repaint'

# Clear screen
bind \cl 'clear; commandline -f repaint'

# List all files
bind \cy 'clear; commandline -f repaint; eza -al'

# List all files in tree format (NOTE: output is often long)
bind \e\[1\;2P 'clear; commandline -f repaint; eza -aT --git-ignore | view-stdin.sh'

# Clear command line
# NOTE: Ctrl+C is bound to `Copy` by Wezterm, Ctrl+X is bound to emulate
# Ctrl+C, which is what fish picks up here.
bind \cc 'commandline -r ""'

# Basic bindings (many are already default)
bind \e cancel # Escape
bind \e\[A up-or-search # Up
bind \e\[B down-or-search # Down
bind \e\[D backward-char # Left
bind \e\[C forward-char # Right
bind \e\[1\;5C forward-word # Ctrl + Right
bind \e\[1\;5D backward-word # Ctrl + Left
bind \e\[H beginning-of-line # Home
bind \e\[F end-of-line # End
bind -k dc delete-char # Delete
bind -k backspace backward-delete-char
bind \t complete # Tab
bind \r execute # Enter
bind '' self-insert
bind ' ' self-insert expand-abbr
bind ';' self-insert expand-abbr
bind '|' self-insert expand-abbr
bind '&' self-insert expand-abbr
bind '>' self-insert expand-abbr
bind '<' self-insert expand-abbr
bind ')' self-insert expand-abbr

# Expand ... to ../..
bind . 'expand-dot-to-double-dot'

# LF CD integration
#-------------------------------------------------------------------------------

source $XDG_CONFIG_HOME/lf/lfcd.fish

# Theme
# see: https://fishshell.com/docs/current/interactive.html#color
#-------------------------------------------------------------------------------

# Configure directory colors (ls, eza, lf).
source $XDG_OPT_HOME/theme/configure-dircolors.fish

# Parse system theme and provide API.
source $XDG_OPT_HOME/theme/theme.fish

# Syntax
set -U fish_color_autosuggestion (color_named 'text_8')
set -U fish_color_command (color_named 'ansi_cyan')
set -U fish_color_comment (color_named 'secondary_5')
set -U fish_color_end (color_named 'green_4') # pipe
set -U fish_color_error (color_named 'ansi_red')
set -U fish_color_normal (color_named 'text_12') # search: text
set -U fish_color_operator (color_named 'green_4')
set -U fish_color_option (color_named 'ansi_bryellow')
set -U fish_color_param (color_named 'secondary_12')
set -U fish_color_quote (color_named 'ansi_yellow')
set -U fish_color_redirection (color_named 'ansi_brmagenta')
set -U fish_color_search_match --background=(color_named 'l1_magenta')
set -U fish_color_valid_path (color_named 'ansi_brcyan') --bold #--underline

# Pager
set -U fish_pager_color_completion (color_named 'text_8')
set -U fish_pager_color_description (color_named 'text_12')
set -U fish_pager_color_prefix (color_named 'yellow_5')
set -U fish_pager_color_progress (color_named 'green_4')
set -U fish_pager_color_selected_background --background=(color_named 'primary_7')
set -U fish_pager_color_selected_completion (color_named 'text_15')
set -U fish_pager_color_selected_description (color_named 'text_15')

# TODO: Find where these colors are used by fish.
# Unknown
set -U fish_color_escape (color_named 'debug')
set -U fish_color_cancel (color_named 'debug') # -r
set -U fish_color_history_current (color_named 'debug') # --bold
set -U fish_color_selection (color_named 'debug') # --bold --background=brblack
