#-------------------------------------------------------------------------------
# Bash debugging utilities
#-------------------------------------------------------------------------------

assert_dependency () {
    if ! command -v "$1" &> /dev/null; then
        >&2 echo "[$(basename "$0")] ERROR: Missing dependency: $1"
        return 1
    fi
    return 0
}
