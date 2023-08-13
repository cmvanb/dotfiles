#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Convert a terminal color index (0 -> 15) to an ANSI terminal escape sequence.
#
# Useful for pretty printing.
#-------------------------------------------------------------------------------

script_name=`basename "$0"`

print_usage() {
    echo "$script_name [--bg=0] [--fg=0] [--reset]" >&2
    echo "" >&2
    echo "--bg: Set the terminal background color. Expects a terminal color index (integer 0 -> 255)." >&2
    echo "--fg: Set the terminal foreground color. Expects a terminal color index (integer 0 -> 255)." >&2
    echo "--reset: Reset the terminal colors to default. Will override --bg and --fg." >&2
    echo "" >&2
    echo "Examples:" >&2
    echo "$script_name --bg=15 --fg=0" >&2
    echo "$script_name --fg=2" >&2
}

background_color=""
foreground_color=""
reset=0
while getopts ":-:" optchar; do
    [[ "${optchar}" == "-" ]] || continue
    case "${OPTARG}" in
        bg=* )
            background_color=${OPTARG#*=}
            ;;
        fg=* )
            foreground_color=${OPTARG#*=}
            ;;
        reset )
            reset=1
            ;;
        help )
            print_usage
            exit -1
            ;;
    esac
done

if [[ -n $background_color ]]; then
    if (( $background_color < 0 || $background_color > 255 )); then
        echo "Error: --bg expects integer 0 -> 255."
        exit 1
    fi

    printf "\e[48:5:%dm" $background_color
fi

if [[ -n $foreground_color ]]; then
    if (( $foreground_color < 0 || $foreground_color > 255 )); then
        echo "Error: --fg expects integer 0 -> 255."
        exit 1
    fi

    printf "\e[38:5:%dm" $foreground_color
fi

if [[ $reset -eq 1 ]]; then
    printf "\e[0m"
fi

