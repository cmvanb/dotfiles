#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Get the currently running linux distribution ID.
#-------------------------------------------------------------------------------

set -euo pipefail

os_release_path=/etc/os-release

if [[ ! -f "$os_release_path" ]]; then
    echo "[$(basename "$0")] ERROR: \`$os_release_path\` does not exist. Unable to get distribution ID."
    exit 1
fi

# Imports
#-------------------------------------------------------------------------------

source ./parse-conf.sh

# Get the distro ID.
#-------------------------------------------------------------------------------

parse_conf "$os_release_path"

declare -n result=conf_vars

echo "${result[ID]}"
