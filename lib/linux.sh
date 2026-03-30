#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Linux specific utilities
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/debug.sh"

# Get the currently running linux distribution ID.
#-------------------------------------------------------------------------------

linux::get_distro_id () {
    local os_release_path=/etc/os-release

    if [[ ! -f "$os_release_path" ]]; then
        debug::error "\`$os_release_path\` does not exist. Unable to get distribution ID."
        exit 1
    fi

    local id
    id=$(sed -n 's/^ID=//p' "$os_release_path" | tr -d '"')
    echo "$id"
}
