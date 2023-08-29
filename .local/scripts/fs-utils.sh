#-------------------------------------------------------------------------------
# Bash file system utilities
#-------------------------------------------------------------------------------

force_link () {
    if [[ -z "$1" ]]; then
        echo "[$(basename "$0")] ERROR: Missing argument: TARGET"
    fi
    if [[ -z "$2" ]]; then
        echo "$(basename "$0") ERROR: Missing argument: LINK_NAME"
    fi

    if [[ -d "$2" ]]; then
        rm -rf "$2"
    elif [[ ! -f "$1" ]]; then
        echo "[$(basename "$0")] ERROR: Tried to link non-existent \`$1\`"
    fi
    ln -sfT "$1" "$2"
}
