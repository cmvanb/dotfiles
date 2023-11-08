#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Lock the computer using waylock
#-------------------------------------------------------------------------------

source "$XDG_OPT_HOME/theme/theme.sh"

waylock -init-color $(color_zerox $gray_0) -input-color $(color_zerox $primary_12) -fail-color $(color_zerox $red_4)

if [ $? != 0 ]; then
    notify-send "Failed to lock screen. Please see \`.local/share/river/session_log\` for details."
fi

