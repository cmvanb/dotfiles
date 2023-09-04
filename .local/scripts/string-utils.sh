#-------------------------------------------------------------------------------
# Bash string utilities
#-------------------------------------------------------------------------------

string_contains () {
    if [[ -z "$1" ]]; then
        echo "[$(basename "$0")] ERROR: Missing argument: string"
        return 1
    fi
    if [[ -z "$2" ]]; then
        echo "$(basename "$0") ERROR: Missing argument: substring[s]"
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
