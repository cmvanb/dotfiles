#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Run sway with custom environment and logging.
#-------------------------------------------------------------------------------

set -euo pipefail

# Load sway environment.
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_CONFIG_HOME/sway/environment.sh"

# Run sway with logging.
#-------------------------------------------------------------------------------

# Ensure state directory exists.
if [[ ! -d "$XDG_STATE_HOME/sway" ]]; then
    mkdir -p "$XDG_STATE_HOME/sway"
fi

# Run sway and save session log file.
sway 2> "$XDG_STATE_HOME/sway/session-log-$(date -Iseconds)"
