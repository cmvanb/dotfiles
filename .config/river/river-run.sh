#!/bin/sh

set -o nounset
set -o pipefail

# Load river environment.
source $XDG_CONFIG_HOME/river/environment.sh

# Ensure data directory exists.
if [[ ! -d $XDG_DATA_HOME/river ]] ; then
    mkdir -p $XDG_DATA_HOME/river
fi

# Run river and save session log file.
/run/current-system/sw/bin/river 2> $XDG_DATA_HOME/river/session_log

