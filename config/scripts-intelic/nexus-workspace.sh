#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Nexus workspace management
#-------------------------------------------------------------------------------

set -euo pipefail

main() {
    local nexus_dir="${XDG_CODE_DIR:?}/nexus"

    spawn-terminal.sh --working-directory "$nexus_dir/agent" --title "Agent"
    spawn-terminal.sh --working-directory "$nexus_dir/hub" --title "Hub"
    spawn-terminal.sh --working-directory "$nexus_dir/nexus-ui" --title "UI"
    spawn-terminal.sh --working-directory "$nexus_dir/agent/sitl" --title "SITL"
}

main "$@"
