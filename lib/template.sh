#-------------------------------------------------------------------------------
# Bash template utilities
#-------------------------------------------------------------------------------

render_esh_template() {
    if [[ -z "$1" ]]; then
        echo "[$(basename "$0")] ERROR: Missing argument: template"
        return 1
    fi
    if [[ ! -f "$1" ]]; then
        echo "[$(basename "$0")] ERROR: Template file does not exist: \`$1\`"
        return 1
    fi
    if [[ -z "$2" ]]; then
        echo "$(basename "$0") ERROR: Missing argument: target"
        return 1
    fi

    # Delete pre-existing target.
    if [[ -f "$2" ]]; then
        rm "$2"
    fi

    esh "$1" > "$2"
}
