#-------------------------------------------------------------------------------
# Wlroots output utilities
#-------------------------------------------------------------------------------

# Imports
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

# Validation
#-------------------------------------------------------------------------------

assert_dependency wlr-randr

# Functions
#-------------------------------------------------------------------------------

wl_get_output () {
    wlr-randr | grep -m1 -n -w "$1"
}

wl_get_outputs () {
    wlr-randr | grep -v '^ ' | awk '{print $1}'
}

wl_output_exists () {
    local output
    output=$(wl_get_output "$1")

    if [[ -z $output ]]; then
        echo "ERROR: output named \`$1\` not found"
        return 1
    fi
}

wl_get_output_transform () {
    local output
    output=$(wl_get_output "$1")

    if [[ -z $output ]]; then
        echo "ERROR: output named \`$1\` not found"
        return 1
    fi

    # Find the line number on which the display info begins.
    local line_number
    line_number=$(echo "$output" | cut -d: -f1)

    # Tail the output from that line and match the first `Transform` line, then slice that match on spaces.
    local transform
    transform=($(wlr-randr | tail -n +"$line_number" | awk '/Transform/{print $line; exit}'))

    # Print the second item in the array
    echo "${transform[1]}"
}

wl_rotate_display () {
    local output="$1"

    local transform
    transform=$(wl_get_output_transform "$output")

    local new_transform
    if [ "$transform" = "normal" ]; then
        new_transform="90"

    elif [ "$transform" = 90 ]; then
        new_transform="180"

    elif [ "$transform" = 180 ]; then
        new_transform="270"

    else
        new_transform="normal"
    fi

    wlr-randr --output "$output" --transform "$new_transform"
}
