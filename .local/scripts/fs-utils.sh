#-------------------------------------------------------------------------------
# Bash file system utilities
#-------------------------------------------------------------------------------

force_link () {
    if [[ -z "$1" ]]; then
        echo "[$(basename "$0")] ERROR: Missing argument: target"
        return 1
    fi
    if [[ -z "$2" ]]; then
        echo "$(basename "$0") ERROR: Missing argument: link name"
        return 1
    fi
    if [[ ! -f "$1" && ! -d "$1" ]]; then
        echo "[$(basename "$0")] ERROR: Tried to link non-existent \`$1\`"
        return 1
    fi

    # Delete pre-existing directory if we are trying to link it.
    if [[ -d "$2" ]]; then
        rm -rf "$2"
    fi

    ln -sfT "$1" "$2"
}
