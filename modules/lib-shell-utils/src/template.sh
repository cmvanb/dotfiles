#-------------------------------------------------------------------------------
# Bash template utilities
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/debug.sh"

# Usage: template::render_mako <template> <destination> [scheme]
#
# A scheme (e.g. carbon-light) renders against that scheme instead of the
# active one.
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

    local render_mako="${XDG_BIN_HOME:-$HOME/.local/bin}/render-mako"
    if [[ -n "${3:-}" ]]; then
        THEME_COLORS="${XDG_CONFIG_HOME:-$HOME/.config}/theme/$3.yaml" \
            "$render_mako" "$1" "$2"
    else
        "$render_mako" "$1" "$2"
    fi
}
