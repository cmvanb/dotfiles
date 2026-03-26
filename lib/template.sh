#-------------------------------------------------------------------------------
# Bash template utilities
#-------------------------------------------------------------------------------

template::render_mako () {
    if [[ -z "$1" ]]; then
        echo "[$(basename "$0")] ERROR: Missing argument: template"
        return 1
    fi
    if [[ -z "$2" ]]; then
        echo "[$(basename "$0")] ERROR: Missing argument: destination"
        return 1
    fi

    # Remove pre-existing links or files that would block deployment.
    if [[ -L "$2" ]] || [[ -f "$2" ]]; then
        rm "$2"
    fi

    render-mako "$1" "$2"
}
