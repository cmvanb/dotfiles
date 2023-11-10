#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Linux specific utilities
#-------------------------------------------------------------------------------

set -euo pipefail

# Get the currently running linux distribution ID.
#-------------------------------------------------------------------------------

get_distro_id () {
    os_release_path=/etc/os-release

    if [[ ! -f "$os_release_path" ]]; then
        echo "[$(basename "$0")] ERROR: \`$os_release_path\` does not exist. Unable to get distribution ID."
        exit 1
    fi

    local bash_dir
    bash_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)

    # NOTE: Import inside the function because this var name is used globally by
    # an upstream script.
    source "$bash_dir/parse-conf.sh"

    parse_conf "$os_release_path"

    declare -n result=conf_vars

    echo "${result[ID]}"
}
