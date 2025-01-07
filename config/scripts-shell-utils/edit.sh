#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Open file with default text editor
#-------------------------------------------------------------------------------

if [[ -n $EDITOR ]]; then
    $EDITOR "$@"
elif [[ -n $VISUAL ]]; then
    $VISUAL "$@"
else
    echo "Neither \$EDITOR nor \$VISUAL environment variables are set."
    exit 1
fi
