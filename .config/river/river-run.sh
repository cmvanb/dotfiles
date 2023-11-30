#!/usr/bin/env bash

set -euo pipefail

# TODO: This should be part of the river/systemd integration.

# Load river environment.
# shellcheck disable=SC1091
source "$XDG_CONFIG_HOME/river/environment.sh"

# Ensure data directory exists.
if [[ ! -d "$XDG_CACHE_HOME/river" ]]; then
    mkdir -p "$XDG_CACHE_HOME/river"
fi

# Run river and save session log file.
river 2> "$XDG_CACHE_HOME/river/session_log"
