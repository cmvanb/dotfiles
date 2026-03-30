#-------------------------------------------------------------------------------
# Bash template utilities
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/debug.sh"

template::render_mako () {
    if [[ -z "$1" ]]; then
        debug::error "Missing argument: template"
        return 1
    fi
    if [[ -z "$2" ]]; then
        debug::error "Missing argument: destination"
        return 1
    fi

    # Remove pre-existing links or files that would block deployment.
    if [[ -L "$2" ]] || [[ -f "$2" ]]; then
        rm "$2"
    fi

    render-mako "$1" "$2"
}
