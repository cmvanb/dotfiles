#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Look up a color's 256-index by theme name.
#-------------------------------------------------------------------------------

# Functions
#-------------------------------------------------------------------------------

# Create the color lookup table and save to disk.
cache_lookup_table () {
    local -A offset_lookup=(
        ["primary"]=16
        ["secondary"]=32
        ["text"]=48
        ["gray"]=64
        ["red"]=80
        ["orange"]=90
        ["yellow"]=100
        ["green"]=110
        ["cyan"]=120
        ["blue"]=130
        ["purple"]=140
        ["magenta"]=150
    )

    local -A color_lookup=(
        ["ansi_black"]=0
        ["ansi_red"]=1
        ["ansi_green"]=2
        ["ansi_yellow"]=3
        ["ansi_blue"]=4
        ["ansi_magenta"]=5
        ["ansi_cyan"]=6
        ["ansi_white"]=7
        ["ansi_brblack"]=8
        ["ansi_brred"]=9
        ["ansi_brgreen"]=10
        ["ansi_bryellow"]=11
        ["ansi_brblue"]=12
        ["ansi_brmagenta"]=13
        ["ansi_brcyan"]=14
        ["ansi_brwhite"]=15
    )

    for i in "${!offset_lookup[@]}"; do
        seq_last=9
        if [[ "$i" = "primary" || "$i" = "secondary" || "$i" = "text" || "$i" = "gray" ]]; then
            seq_last=15
        fi
        for j in $(seq 0 $seq_last); do
            local color_name="$i"_"$j"
            local palette_offset="${offset_lookup["$i"]}"
            local index=$((palette_offset + j))
            color_lookup[$color_name]="$index"
        done
    done

    mkdir -p "$XDG_CACHE_HOME/theme"
    declare -p color_lookup > "$XDG_CACHE_HOME/theme/color-256-lookup"
}

# Look up a color's 256-index by theme name.
color_256 () {
    if [[ ! -f "$XDG_CACHE_HOME/theme/color-256-lookup" ]]; then
        cache_lookup_table
    fi

    source "$XDG_CACHE_HOME/theme/color-256-lookup"

    printf "%s" "${color_lookup["$1"]}"
}

# Print usage instructions.
print_usage() {
    script_name=$(basename "$0")

    echo "$script_name COLOR_NAME [--cache]" >&2
    echo "" >&2
    echo "--cache: Cache the color lookup table" >&2
    echo "" >&2
    echo "Examples:" >&2
    echo "$script_name magenta_5" >&2
    echo "$script_name primary_15" >&2
    echo "$script_name --cache" >&2
}

# Handle options.
#-------------------------------------------------------------------------------

while getopts ":-:" optchar; do
    [[ "${optchar}" == "-" ]] || continue
    case "${OPTARG}" in
        cache)
            cache_lookup_table
            exit 0
            ;;
        help)
            print_usage
            exit 0
            ;;
    esac
done

# Validation.
#-------------------------------------------------------------------------------

if [ "$#" -ne 1 ]; then
    echo "Expected only one argument: the theme name of the color (e.g. \`magenta_5\`). Received $# arguments."
    exit 1
fi

# Look up a color's 256-index by theme name.
#-------------------------------------------------------------------------------

color_256 "$1"
