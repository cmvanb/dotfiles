#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Niri workspace navigation
#
# Named workspaces are declared in workspaces.kdl and always exist. Traversal
# skips empty workspaces, so the declared ones stay out of the way until they
# hold windows.
#-------------------------------------------------------------------------------

set -euo pipefail

# Dependencies
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

debug::assert_dependency niri
debug::assert_dependency jq

declared_file="${XDG_CONFIG_HOME:-$HOME/.config}/niri/workspaces.kdl"
history_file="${XDG_RUNTIME_DIR:-/tmp}/niri-ws-history"
history_size=50

usage() {
    echo "$(basename "$0") <step|back|fresh|daemon> [options]"
    echo "Options:"
    echo "    step up|down     Focus the previous or next occupied workspace on the"
    echo "                     focused output, wrapping around."
    echo "    back [--move]    Focus the most recent occupied workspace, or move the"
    echo "                     focused window there."
    echo "    fresh [--move]   Focus the trailing empty workspace, or move the focused"
    echo "                     window there."
    echo "    daemon           Record focus history and remove the names of empty"
    echo "                     hidden workspaces named at runtime."
    exit 1
}

focused_output() {
    niri msg -j focused-output | jq -r '.name'
}

focused_window() {
    niri msg -j focused-window | jq -r '.id // empty'
}

# Step through occupied workspaces
#-------------------------------------------------------------------------------

ws_step() {
    local direction=$1 idx

    idx=$(niri msg -j workspaces | jq -r --arg direction "$direction" '
        (.[] | select(.is_focused)) as $focused
        | [.[] | select(.output == $focused.output and .active_window_id != null and .id != $focused.id)]
        | sort_by(.idx) as $occupied
        | if $direction == "down"
            then ($occupied | map(select(.idx > $focused.idx))) + $occupied
            else ($occupied | map(select(.idx < $focused.idx)) | reverse) + ($occupied | reverse)
          end
        | (first | .idx) // empty')

    [[ -n $idx ]] || return 0
    niri msg action focus-workspace "$idx"
}

# Return to the most recent occupied workspace
#-------------------------------------------------------------------------------

ws_back() {
    local move=$1 target output idx name current_output window_id

    [[ -f $history_file ]] || return 0

    target=$(niri msg -j workspaces | jq -r --rawfile history "$history_file" '
        INDEX(.id) as $by_id
        | [$history | splits("\n") | $by_id[.] // empty
           | select((.is_focused | not) and .active_window_id != null)]
        | first // empty
        | [.output, .idx, .name // ""] | @tsv')

    [[ -n $target ]] || return 0
    IFS=$'\t' read -r output idx name <<< "$target"
    current_output=$(focused_output)

    if [[ $move == false ]]; then
        # An index resolves on the focused output.
        [[ -n $name || $output == "$current_output" ]] || niri msg action focus-monitor "$output"
        niri msg action focus-workspace "${name:-$idx}"
        return 0
    fi

    window_id=$(focused_window)
    [[ -n $window_id ]] || return 0

    if [[ -n $name || $output == "$current_output" ]]; then
        niri msg action move-window-to-workspace --window-id "$window_id" --focus false "${name:-$idx}"
    else
        # An index resolves on the window's output, so cross outputs first.
        niri msg action move-window-to-monitor --id "$window_id" "$output"
        niri msg action move-window-to-workspace --window-id "$window_id" --focus false "$idx"
        niri msg action focus-monitor "$current_output"
    fi
}

# Open a fresh workspace
#
# niri keeps one empty unnamed workspace at the end of each output.
#-------------------------------------------------------------------------------

ws_fresh() {
    local move=$1 idx

    idx=$(niri msg -j workspaces | jq -r '
        (.[] | select(.is_focused)) as $focused
        | [.[] | select(.output == $focused.output and .name == null and .active_window_id == null)]
        | (max_by(.idx) | .idx) // empty')

    [[ -n $idx ]] || return 0

    if [[ $move == true ]]; then
        niri msg action move-window-to-workspace --focus false "$idx"
    else
        niri msg action focus-workspace "$idx"
    fi
}

# Daemon
#-------------------------------------------------------------------------------

recent=()

record() {
    local id=$1 old
    [[ -n $id && $id != "${recent[0]:-}" ]] || return 0

    local -a kept=("$id")
    for old in "${recent[@]}"; do
        [[ $old == "$id" ]] || kept+=("$old")
    done
    recent=("${kept[@]:0:history_size}")

    printf '%s\n' "${recent[@]}" > "$history_file.tmp"
    mv "$history_file.tmp" "$history_file"
}

# Declared workspaces must keep their names, or their bindings stop resolving.
reap() {
    local declared name
    declared=$({ grep -oP '^workspace "\K[^"]+' "$declared_file" 2> /dev/null || true; } | jq -R -s -c 'ascii_downcase | split("\n")')

    niri msg -j workspaces \
        | jq -r --argjson declared "$declared" '
            .[] | select(.name != null and (.is_active | not) and .active_window_id == null)
            | .name | select(ascii_downcase | IN($declared[]) | not)' \
        | while IFS= read -r name; do
            niri msg action unset-workspace-name "$name"
        done
}

ws_daemon() {
    # Anchored, so shells whose command line mentions the daemon survive.
    pkill -f "^bash [^ ]*niri-ws(\.sh)? daemon$" --ignore-ancestors || true

    local event id
    while IFS=$'\t' read -r event id; do
        [[ $event == focused ]] && record "$id"
        reap
    done < <(niri msg -j event-stream | jq --unbuffered -r '
        if .WorkspacesChanged then ["focused", (.WorkspacesChanged.workspaces[] | select(.is_focused) | .id)]
        elif .WorkspaceActivated.focused then ["focused", .WorkspaceActivated.id]
        elif (.WorkspaceActivated or .WorkspaceActiveWindowChanged) then ["changed"]
        else empty
        end | @tsv')
}

# Dispatch
#-------------------------------------------------------------------------------

move=false
[[ ${2:-} == "--move" ]] && move=true

case "${1:-}:${2:-}:$#" in
    step:up:2 | step:down:2)
        ws_step "$2"
        ;;
    back::1 | back:--move:2)
        ws_back "$move"
        ;;
    fresh::1 | fresh:--move:2)
        ws_fresh "$move"
        ;;
    daemon::1)
        ws_daemon
        ;;
    *)
        usage
        ;;
esac
