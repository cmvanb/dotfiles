#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Workspace sessions (wsesh)
#
# Launches a named set of programs into sway workspaces, defined in
# $XDG_CONFIG_HOME/sway/wsesh/<name>.toml. See wsesh/default.toml for the
# entry format (terminal, browser, app, focus).
#-------------------------------------------------------------------------------

set -euo pipefail

# Dependencies
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

debug::assert_dependency tomlq
debug::assert_dependency swaymsg

wsesh_dir="${XDG_CONFIG_HOME:-$HOME/.config}/sway/wsesh"

usage() {
    echo "$(basename "$0") <launch|select> [name]"
    echo "Options:"
    echo "    launch NAME    Launch the wsesh file wsesh/NAME.toml."
    echo "    select         Pick a wsesh file with spawn-launcher.sh, then launch it."
    exit 1
}

# Run one wsesh entry
#-------------------------------------------------------------------------------

spawn_entry() {
    # Fields are unit-separator (\x1f) delimited, not tab: bash's `read`
    # collapses consecutive *tab* delimiters (it treats tab as IFS
    # whitespace), which would silently swallow empty fields.
    local type workspace cwd command floating title browser session exec_cmd wait_for_network
    IFS=$'\x1f' read -r type workspace cwd command floating title browser session exec_cmd wait_for_network

    local cmd=()

    case "$type" in
        terminal)
            cmd=(spawn-terminal.sh)
            [[ -n $cwd ]] && cmd+=(--working-directory "$cwd")
            [[ -n $command ]] && cmd+=(--command "$command")
            [[ -n $title ]] && cmd+=(--title "$title")
            [[ $floating == "true" ]] && cmd+=(--floating)
            ;;

        browser)
            if [[ -n $session ]]; then
                cmd=(open-browser-session.sh --session "$session")
                [[ -n $browser ]] && cmd+=(--browser "$browser")
            else
                cmd=("${browser:-${BROWSER:-qutebrowser}}")
            fi
            ;;

        app)
            cmd=(sh -c "$exec_cmd")
            ;;

        focus)
            swaymsg workspace "$workspace"
            return
            ;;

        *)
            debug::error "Unknown entry type: $type"
            return
            ;;
    esac

    local quoted
    quoted=$(printf '%q ' "${cmd[@]}")

    if [[ $wait_for_network == "true" ]]; then
        quoted="sh -c $(printf '%q' "nm-online -qs && sleep 1 && $quoted")"
    fi

    # A single pair of sway-level double quotes shields the shell-quoted
    # command from sway's own command-line tokenizer (a separate grammar
    # from POSIX shell — it splits on unquoted `;`/`,` too).
    if [[ -n $workspace ]]; then
        swaymsg "workspace $workspace; exec \"$quoted\""
    else
        swaymsg "exec \"$quoted\""
    fi
}

# Launch a wsesh file
#-------------------------------------------------------------------------------

wsesh_launch() {
    local name="$1"
    local file="$wsesh_dir/$name.toml"

    if [[ ! -f $file ]]; then
        debug::error_notify "No such wsesh '$name' ($file)"
        exit 1
    fi

    local entries
    if ! entries=$(tomlq -r '.entry[] | [
        .type,
        (.workspace // ""),
        (.cwd // ""),
        (.command // ""),
        (.floating // "" | tostring),
        (.title // ""),
        (.browser // ""),
        (.session // ""),
        (.exec // ""),
        (.wait_for_network // "" | tostring)
    ] | join("\u001f")' "$file"); then
        debug::error_notify "Failed to parse wsesh file: $file"
        exit 1
    fi

    while IFS= read -r line; do
        spawn_entry <<< "$line"
    done <<< "$entries"
}

# Pick a wsesh file to launch
#-------------------------------------------------------------------------------

wsesh_select() {
    debug::assert_dependency spawn-launcher.sh

    local name
    name=$(find -L "$wsesh_dir" -maxdepth 1 -name '*.toml' -exec basename {} .toml \; \
        | sort \
        | spawn-launcher.sh --menu --prompt="Launch workspace session..." 2> /dev/null) || exit 0

    [[ -z $name ]] && exit 0

    wsesh_launch "$name"
}

# Dispatch
#-------------------------------------------------------------------------------

case "${1:-}" in
    launch)
        [[ -n "${2:-}" ]] || usage
        wsesh_launch "$2"
        ;;
    select)
        wsesh_select
        ;;
    *)
        usage
        ;;
esac
