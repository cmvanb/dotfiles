#-------------------------------------------------------------------------------
# Fish interactive configuration
#-------------------------------------------------------------------------------

# General
#-------------------------------------------------------------------------------

# STTY configuration.
source $XDG_CONFIG_HOME/shell-stty/stty-config

# Save python history in an XDG compliant directory.
set -x PYTHON_HISTORY $XDG_DATA_HOME/python/history

# Aliases & Abbreviations
#-------------------------------------------------------------------------------

fish_shared_aliases
fish_deployed_aliases

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
set -U fish_color_end (color_named 'green_4')  # pipe
set -U fish_color_error (color_named 'ansi_red')
set -U fish_color_normal (color_named 'text_12')  # search: text
set -U fish_color_operator (color_named 'green_4')
set -U fish_color_option (color_named 'ansi_bryellow')
set -U fish_color_param (color_named 'secondary_12')
set -U fish_color_quote (color_named 'ansi_yellow')
set -U fish_color_redirection (color_named 'ansi_brmagenta')
set -U fish_color_search_match --background=(color_named 'l1_magenta')
set -U fish_color_valid_path (color_named 'ansi_brcyan') --bold #--underline
set -U fish_color_escape (color_named 'ansi_brmagenta')  # escape characters

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
set -U fish_color_cancel (color_named 'debug') # -r
set -U fish_color_history_current (color_named 'debug') # --bold
set -U fish_color_selection (color_named 'debug')  # Used when manually selecting text.

# Terminal color support
#-------------------------------------------------------------------------------

if test "$TERM" = "alacritty"
or test "$TERM" = "xterm-256color"
or test "$TERM" = "xterm-ghostty"
    set -g fish_term24bit 1
end

# Integrations
#-------------------------------------------------------------------------------

# Enable direnv
if command -v direnv >/dev/null
    direnv hook fish | source
end

# Enable Zoxide
if command -v zoxide >/dev/null
    zoxide init fish | source
end

# LF CD integration
source $XDG_CONFIG_HOME/lf/lfcd.fish

# Yazi CD Integration
source $XDG_CONFIG_HOME/yazi/yzcd.fish
