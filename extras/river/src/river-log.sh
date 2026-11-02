#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Tail the latest river log file
#-------------------------------------------------------------------------------

latest=$(fd .log "$XDG_STATE_HOME/river/" | tail -n 1)

if [[ -z $latest ]]; then
    echo "No river log file found."
    exit 1
fi

tail -f -n +1 "$latest"
