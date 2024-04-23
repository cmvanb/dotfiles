#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Run river with custom environment and logging.
#
# TODO: This should be part of the river/systemd integration.
#-------------------------------------------------------------------------------

set -euo pipefail

# Load river environment.
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_CONFIG_HOME/river/environment.sh"

# Run river with logging.
#-------------------------------------------------------------------------------

# Ensure state directory exists.
if [[ ! -d "$XDG_STATE_HOME/river" ]]; then
    mkdir -p "$XDG_STATE_HOME/river"
fi

# Run river and save session log file.
river 2> "$XDG_STATE_HOME/river/session-log-$(date -Iseconds)"
