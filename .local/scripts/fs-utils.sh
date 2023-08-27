#-------------------------------------------------------------------------------
# Bash file system utilities
#-------------------------------------------------------------------------------

force_link () {
    if [[ -z "$1" ]]; then
        echo "$(basename "$0") missing argument: TARGET"
    fi
    if [[ -z "$2" ]]; then
        echo "$(basename "$0") missing argument: LINK_NAME"
    fi

    if [[ -d "$2" ]]; then
        rm -rf "$2"
    fi
    ln -sfT "$1" "$2"
}
