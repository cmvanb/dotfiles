#-------------------------------------------------------------------------------
# Bash debugging utilities
#-------------------------------------------------------------------------------

assert_dependency () {
    if ! command -v "$1" &> /dev/null; then
        echo "["$(basename "$0")"] ERROR: Missing dependency: $1"
        exit 1
    fi
}
