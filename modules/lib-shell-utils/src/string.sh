#-------------------------------------------------------------------------------
# Bash string utilities
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/debug.sh"

string_contains () {
    if [[ -z "$1" ]]; then
        debug::error "Missing argument: string"
        return 1
    fi
    if [[ -z "$2" ]]; then
        debug::error "Missing argument: substring[s]"
        return 1
    fi

    string="$1"
    substrings="${@:2}"

    for substring in $substrings; do
        if [[ $string == *"$substring"* ]]; then
            return 0
        fi
    done

    return 1
}
