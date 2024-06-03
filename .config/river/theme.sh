#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Apply River theme
#
# NOTE: The ${var:?} syntax fails if var is unassigned. Use this to appease shellcheck SC2154.
#-------------------------------------------------------------------------------

declare config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
declare opt_dir=${XDG_OPT_HOME:-$HOME/.local/opt}

# Cursor theme.
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$opt_dir/theme/theme.sh"

export XCURSOR_THEME=${cursor_theme:?}
export XCURSOR_SIZE=${cursor_size:?}

# Styling
#-------------------------------------------------------------------------------

riverctl background-color "$(color_zerox "${system_bg:?}")"
riverctl border-color-focused "$(color_zerox "${primary_8:?}")"
riverctl border-color-unfocused "$(color_zerox "${primary_3:?}")"
riverctl border-color-urgent "$(color_zerox "${red_4:?}")"

riverctl border-width 3

riverctl xcursor-theme "${cursor_theme:?}" "${cursor_size:?}"

# Wallpaper
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$config_dir/wallpaper/wallpaper.sh"

# Status bar
#-------------------------------------------------------------------------------

pkill -x waybar
riverctl spawn waybar
