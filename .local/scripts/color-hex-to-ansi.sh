#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Convert a hexadecimal color code (000000 -> ffffff) to an ANSI terminal escape
# sequence.
#
# Useful for pretty printing.
#-------------------------------------------------------------------------------

script_name=`basename "$0"`

print_usage() {
    echo "$script_name [--bg=ffffff] [--fg=ffffff] [--reset]" >&2
    echo "" >&2
    echo "--bg: Set the terminal background color. Expects a hexadecimal color code (000000 -> ffffff)." >&2
    echo "--fg: Set the terminal foreground color. Expects a hex formatted color code (000000 -> ffffff)." >&2
    echo "--reset: Reset the terminal colors to default. Will override --bg and --fg." >&2
    echo "" >&2
    echo "Examples:" >&2
    echo "$script_name --bg=ffffff --fg=000000" >&2
    echo "$script_name --fg=a0bb9c" >&2
    echo "$script_name --reset" >&2
}

background_color=""
foreground_color=""
while getopts ":-:" optchar; do
    [[ "${optchar}" == "-" ]] || continue
    case "${OPTARG}" in
        bg=*)
            background_color=${OPTARG#*=}
            ;;
        fg=*)
            foreground_color=${OPTARG#*=}
            ;;
        reset)
            reset=true
            ;;
        help)
            print_usage
            exit -1
            ;;
    esac
done

if [[ -n $background_color ]]; then
    if [[ ${#background_color} -ne 6 ]]; then
        echo "Error: --bg expects 6 character string."
        exit 1
    fi

    # Slice values out of string
    red_value="${background_color:0:2}"
    green_value="${background_color:2:2}"
    blue_value="${background_color:4:2}"
    # Convert to decimal
    printf "\e[48:2:%d:%d:%dm" $((16#$red_value)) $((16#$green_value)) $((16#$blue_value))
fi

if [[ -n $foreground_color ]]; then
    if [[ ${#foreground_color} -ne 6 ]]; then
        echo "Error: --fg expects 6 character string."
        exit 1
    fi

    # Slice values out of string
    red_value="${foreground_color:0:2}"
    green_value="${foreground_color:2:2}"
    blue_value="${foreground_color:4:2}"
    # Convert to decimal
    printf "\e[38:2:%d:%d:%dm" $((16#$red_value)) $((16#$green_value)) $((16#$blue_value))
fi

if [[ "$reset" == true ]]; then
    printf "\e[0m"
fi

