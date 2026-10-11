#-------------------------------------------------------------------------------
# Bash template utilities
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/debug.sh"

# Every render is recorded here so `theme switch` can re-render it against
# another color scheme without re-running deploy scripts. Fields are
# tab-separated; `-` marks an empty field so `read` keeps the columns aligned.
template::manifest_path () {
    echo "${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/renders"
}

template::_record () {
    local destination="$1" template="$2" scheme="$3"
    local manifest
    manifest="$(template::manifest_path)"

    mkdir -p "$(dirname "$manifest")"
    touch "$manifest"

    local entries
    entries=$(awk -F '\t' -v dest="$destination" '$1 != dest' "$manifest")
    {
        [[ -n "$entries" ]] && printf '%s\n' "$entries"
        printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
            "$destination" "$template" "${scheme:--}" \
            "${DEPLOY_PROFILE:--}" "${DEPLOY_DISTRO:--}" "${DEPLOY_WM:--}" "${DEPLOY_HOST:--}"
    } > "$manifest"
}

# Usage: template::render_mako <template> <destination> [scheme]
#
# Without a scheme the output follows the active color scheme and is
# re-rendered by `theme switch`. A scheme (e.g. carbon-light) pins the output.
template::render_mako () {
    if [[ -z "$1" ]]; then
        debug::error "Missing argument: template"
        return 1
    fi
    if [[ -z "$2" ]]; then
        debug::error "Missing argument: destination"
        return 1
    fi

    local template destination scheme="${3:-}"
    template="$(realpath -s "$1")"
    destination="$(realpath -ms "$2")"

    # Remove pre-existing links or files that would block deployment.
    if [[ -L "$destination" ]] || [[ -f "$destination" ]]; then
        rm "$destination"
    fi

    local render_mako="${XDG_BIN_HOME:-$HOME/.local/bin}/render-mako"
    if [[ -n "$scheme" ]]; then
        THEME_COLORS="${XDG_CONFIG_HOME:-$HOME/.config}/theme/$scheme.yaml" \
            "$render_mako" "$template" "$destination" || return 1
    else
        "$render_mako" "$template" "$destination" || return 1
    fi

    template::_record "$destination" "$template" "$scheme"
}
