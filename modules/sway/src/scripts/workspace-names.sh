#-------------------------------------------------------------------------------
# Named workspace lookup
#
# Resolves a named workspace (e.g. "mail") to its "NUM:name" form (e.g.
# "102:mail") by reading workspaces.conf (rendered from
# workspaces.mako.conf's `named_workspaces` list), so callers don't have to
# hardcode workspace numbers. Shared by wsesh.sh and sws.sh.
#-------------------------------------------------------------------------------

workspace_names_conf="${XDG_CONFIG_HOME:-$HOME/.config}/sway/outputs/workspaces.conf"

# Usage: workspace_resolve_name <name>
# Prints the matching "NUM:name" workspace, or nothing if there's no match.
workspace_resolve_name() {
    local name="$1"
    awk -v name="$name" '$1 == "workspace" && $2 ~ ("^[0-9]+:" name "$") { print $2; exit }' "$workspace_names_conf"
}
