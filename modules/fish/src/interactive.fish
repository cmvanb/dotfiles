#-------------------------------------------------------------------------------
# Fish interactive configuration
#-------------------------------------------------------------------------------

# General
#-------------------------------------------------------------------------------

# Save python history in an XDG compliant directory.
set -x PYTHON_HISTORY $XDG_DATA_HOME/python/history

# Aliases & Abbreviations
#-------------------------------------------------------------------------------

fish_shared_aliases
fish_deployed_aliases

# Theme
# see: https://fishshell.com/docs/current/interactive.html#color
#-------------------------------------------------------------------------------

# Configure directory colors (ls, eza).
eval (dircolors --c-shell $XDG_CONFIG_HOME/theme/dircolors)
set -x EZA_COLORS (tr -d '\n' < $XDG_CONFIG_HOME/theme/eza-colors)$LS_COLORS

# Parse system theme and provide API.
source $XDG_OPT_HOME/theme/theme.fish

# Syntax
set -U fish_color_autosuggestion (color_named 'syn_comment')
set -U fish_color_command (color_named 'syn_function')
set -U fish_color_comment (color_named 'syn_comment')
set -U fish_color_end (color_named 'syn_delimiter')  # pipe
set -U fish_color_error (color_named 'ansi_red')
set -U fish_color_normal (color_named 'editor_text_normal')
set -U fish_color_operator (color_named 'syn_delimiter')
set -U fish_color_option (color_named 'syn_special')  # ansi_bryellow
set -U fish_color_param (color_named 'syn_param')
set -U fish_color_quote (color_named 'syn_string')
set -U fish_color_redirection (color_named 'magenta_6')  # ansi_brmagenta
set -U fish_color_search_match --background=(color_named 'primary_7')
set -U fish_color_valid_path (color_named 'ansi_blue')  # ansi_brcyan
set -U fish_color_escape (color_named 'syn_special')  # escape characters

# Pager
set -U fish_pager_color_completion (color_named 'text_8')
set -U fish_pager_color_description (color_named 'editor_text_normal')
set -U fish_pager_color_prefix (color_named 'yellow_6')
set -U fish_pager_color_progress (color_named 'syn_delimiter')
set -U fish_pager_color_selected_background --background=(color_named 'menu_selection_bg')
set -U fish_pager_color_selected_completion (color_named 'menu_selection_fg')
set -U fish_pager_color_selected_description (color_named 'editor_text_normal')

# Unknown
# TODO: Find where these colors are used by fish.
set -U fish_color_cancel (color_named 'debug') # -r
set -U fish_color_history_current (color_named 'debug') # --bold
set -U fish_color_selection (color_named 'selection_bg')  # Used when manually selecting text.

# Terminal color support
#-------------------------------------------------------------------------------

if test "$TERM" = "alacritty"
or test "$TERM" = "xterm-256color"
or test "$TERM" = "xterm-ghostty"
    set -g fish_term24bit 1
end
