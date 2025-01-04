#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Lock the computer using waylock
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/theme/theme.sh"

if ! waylock \
    -init-color "$(color_zerox "$gray_0")" \
    -input-color "$(color_zerox "$primary_12")" \
    -fail-color "$(color_zerox "$red_4")" \
    ; then
    notify-send "Failed to lock screen."
fi
