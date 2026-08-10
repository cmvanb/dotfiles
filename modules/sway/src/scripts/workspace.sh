#-------------------------------------------------------------------------------
# Sway workspace library
#
# Shared workspace helpers for sway scripts (currently wsesh.sh and sws.sh).
# Requires debug.sh to already be sourced by the caller for workspace::rename's
# error reporting, and rename-workspace.sh to sit alongside this file.
#-------------------------------------------------------------------------------

workspace_names_conf="${XDG_CONFIG_HOME:-$HOME/.config}/sway/outputs/workspaces.conf"
workspace_script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# Resolve a named workspace (e.g. "mail") to its "NUM:name" form (e.g.
# "102:mail") by reading workspaces.conf (rendered from
# workspaces.mako.conf's `named_workspaces` list), so callers don't have to
# hardcode workspace numbers.
#
# Usage: workspace::resolve_name <name>
# Prints the matching "NUM:name" workspace, or nothing if there's no match.
#-------------------------------------------------------------------------------

workspace::resolve_name() {
    local name="$1"
    awk -v name="$name" '$1 == "workspace" && $2 ~ ("^[0-9]+:" name "$") { print $2; exit }' "$workspace_names_conf"
}

# Resolve a workspace name to its "NUM:name" form
#
# A bare number (e.g. "1") addresses an unnamed, per-output workspace and is
# passed through unchanged. Anything else is looked up via
# workspace::resolve_name(), so callers can say `workspace = "mail"` instead
# of hardcoding the number.
#
# Usage: workspace::resolve <name>
#-------------------------------------------------------------------------------

workspace::resolve() {
    local name="$1"
    [[ -z $name ]] && return 0

    if [[ $name =~ ^[0-9]+$ ]]; then
        echo "$name"
        return 0
    fi

    local resolved
    resolved=$(workspace::resolve_name "$name")

    if [[ -z $resolved ]]; then
        debug::error "Unknown workspace name: $name"
        return 1
    fi

    echo "$resolved"
}

# Rename a resolved workspace via rename-workspace.sh
#
# Lets a caller give an ad-hoc numeric workspace (e.g. "1") a display name
# without pre-registering it in workspaces.mako.conf's named_workspaces list.
# rename-workspace.sh renames whichever workspace is focused, so this
# switches to it first, then prints the renamed "NUM:name" so the caller can
# address the workspace by its new name -- sway matches `workspace <name>`
# on the exact string, so any later command still using the old bare number
# would miss the renamed workspace and spawn a fresh empty one under it.
#
# Usage: workspace::rename <workspace> <new_name>
#-------------------------------------------------------------------------------

workspace::rename() {
    local workspace="$1"
    local new_name="$2"

    if [[ -z $workspace ]]; then
        debug::error "workspace_name given without a workspace"
        return 1
    fi

    swaymsg workspace "$workspace" > /dev/null
    "$workspace_script_dir/rename-workspace.sh" "$new_name" > /dev/null

    echo "${workspace%%:*}:$new_name"
}
