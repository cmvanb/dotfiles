#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Niri named workspace daemon
#
# Follows the niri event stream and enforces sway's named workspace behavior:
#
#   reap    A named workspace that is empty and hidden loses its name, so niri
#           removes it. Covers names given by rename-workspace.sh too.
#   assign  A new window of an assigned app moves to its named workspace
#           (sway's `assign`).
#-------------------------------------------------------------------------------

set -euo pipefail

# Dependencies
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

debug::assert_dependency niri
debug::assert_dependency jq
debug::assert_dependency flock

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
# Shared with ws.sh, which holds it while it sets up a named workspace.
lock_file="${XDG_RUNTIME_DIR:-/tmp}/niri-workspaces.lock"

declare -A assignments=(
    [org.gnome.Geary]=mail
    [discord]=chat
    [com.tosta.zapzap]=chat
    [Bitwarden]=auth
    [spotify]=audio
    [org.pulseaudio.pavucontrol]=audio
)

usage() {
    echo "$(basename "$0") daemon"
    echo "Remove empty hidden named workspaces and move assigned apps."
    exit 1
}

# Rules
#-------------------------------------------------------------------------------

reap() {
    local name
    (
        flock 9
        niri msg -j workspaces \
            | jq -r '.[] | select(.name != null and (.is_active | not) and .active_window_id == null) | .name' \
            | while IFS= read -r name; do
                niri msg action unset-workspace-name "$name"
            done
    ) 9> "$lock_file"
}

declare -A handled=()

assign() {
    local id=$1 app_id=$2
    local name=${assignments[$app_id]:-}

    [[ -n $name && -z ${handled[$id]:-} ]] || return 0
    handled[$id]=1
    "$script_dir/ws.sh" move "$name" --window-id "$id" || true
}

# Daemon
#-------------------------------------------------------------------------------

daemon() {
    # Kill any previous instance before taking over.
    pkill -f "workspaces.sh daemon" --ignore-ancestors || true

    local event id app_id window
    # The stream opens with WindowsChanged, which lists the windows present at
    # start: those are marked handled so a restart does not move them.
    while IFS=$'\t' read -r event id app_id; do
        case "$event" in
            existing)
                for window in $id; do handled[$window]=1; done
                ;;
            window)
                assign "$id" "$app_id"
                ;;
        esac
        reap
    done < <(niri msg -j event-stream | jq --unbuffered -r '
        if .WindowsChanged then ["existing", ([.WindowsChanged.windows[].id] | join(" "))]
        elif .WindowOpenedOrChanged then ["window", .WindowOpenedOrChanged.window.id, (.WindowOpenedOrChanged.window.app_id // "")]
        elif (.WorkspacesChanged or .WorkspaceActivated or .WindowClosed) then ["workspace"]
        else empty
        end | @tsv')
}

# Dispatch
#-------------------------------------------------------------------------------

case "${1:-}" in
    daemon)
        daemon
        ;;
    *)
        usage
        ;;
esac
