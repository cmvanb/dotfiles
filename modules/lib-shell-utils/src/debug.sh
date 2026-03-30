#-------------------------------------------------------------------------------
# Bash debugging utilities
#-------------------------------------------------------------------------------

# Print an error message to stderr.
# Usage: debug::error <message>
debug::error() {
    >&2 echo "[$(basename "$0")] ERROR: $*"
}

# Print an error message to stderr and dispatch a desktop notification.
# Usage: debug::error_notify <message>
debug::error_notify() {
    local msg="$*"
    >&2 echo "[$(basename "$0")] ERROR: $msg"
    notify-send "$(basename "$0")" "$msg"
}

# Assert that a dependency (command) is available on PATH.
# Usage: debug::assert_dependency <command>
debug::assert_dependency() {
    if ! command -v "$1" &> /dev/null; then
        debug::error "Missing dependency: $1"
        return 1
    fi
    return 0
}

# Deprecated aliases — kept for backwards compatibility.
assert_dependency() { debug::assert_dependency "$@"; }
