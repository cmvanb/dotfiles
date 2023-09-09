#-------------------------------------------------------------------------------
# Fish interactive configuration
#
# Unfortunately, it's not trivial to source a POSIX shell script from fish, so
# some parts of the generic script may need to be duplicated here.
#
# NOTE: Although `bass` works, it degrades performance to an unacceptable level.
#   `bass 'source /home/casper/.config/shell/generic/interactive'`
#-------------------------------------------------------------------------------

# NOTE: In it's present form, the generic interactive script *can* be sourced.
# That may not always be true.
source $XDG_CONFIG_HOME/shell/generic/interactive

# Aliases & Abbreviations
#-------------------------------------------------------------------------------

alias eza "eza -l --group-directories-first"
alias bat "bat --force-colorization --no-paging --style=grid,numbers"

abbr -a gs git status
abbr -a gsu git status -u
abbr -a gl 'git log --pretty=\'%C(yellow)[%h]%C(reset) %<(16,trunc)%ad %C(cyan)%an%C(reset) %C(green)%s%C(reset)\' --date=format:\'%Y-%m-%d %H:%M\''
abbr -a gd git diff
abbr -a gds git diff --staged
abbr -a ga git add
abbr -a gaa git add -A
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
abbr -a lf lfcd
abbr -a ls eza
abbr -a lsa eza -a
abbr -a lst eza -T --git-ignore
abbr -a lsat eza -aT --git-ignore
abbr -a ip ip -c

# Bindings
#-------------------------------------------------------------------------------

# Unbindings
bind \cb ''

# Open file browser
bind \cf 'lfcd; commandline -f repaint'

# Open editor
bind \ce 'edit; commandline -f repaint'

# Clear screen
bind \cl 'clear; commandline -f repaint'

# List files
bind \cy 'clear; commandline -f repaint; eza -al'

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

# Colors
# see: https://fishshell.com/docs/current/interactive.html#color
#-------------------------------------------------------------------------------

# Import and parse system colors.
source $XDG_CONFIG_HOME/theme/theme.fish

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

# Unknown
# TODO: Find where these colors are used by fish.
set -U fish_color_escape (color_named 'debug')
set -U fish_color_cancel (color_named 'debug') # -r
set -U fish_color_history_current (color_named 'debug') # --bold
set -U fish_color_selection (color_named 'debug') # --bold --background=brblack

# LF CD integration
#-------------------------------------------------------------------------------

source $XDG_CONFIG_HOME/lf/lfcd.fish

