#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Spawn a launcher menu.
#-------------------------------------------------------------------------------

# Imports
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

assert_dependency "$LAUNCHER"

# Parse arguments
#-------------------------------------------------------------------------------

prompt=""
menu=false

usage() {
    echo "$(basename "$0") [options]"
    echo "Options:"
    echo "    -m, --menu             Run launcher in menu mode."
    echo "    -p, --prompt PROMPT    Prompt text for the launcher."
    echo "    -h, --help             Display this help message."
    exit 1
}

parse_long_options() {
    case "$1" in
        --menu=*)
            echo "Error: --menu does not take arguments"
            usage
            ;;
        --menu)
            menu=true
            ;;

        --prompt=*)
            prompt="${1#*=}"
            ;;
        --prompt)
            # TODO: This is broken. Equals sign required for now.
            if [ -n "$2" ]; then
                prompt="$2"
                return 2
            else
                echo "Error: --prompt requires an argument"
                usage
            fi
            ;;

        --help)
            usage
            ;;

        *)
            echo "Error: Unknown option: $1"
            usage
            ;;
    esac
    return 1
}

while [ $# -gt 0 ]; do
    case "$1" in
        --*=*|--*)
            parse_long_options "$1" "$2"
            shift $?
            ;;

        -*)
            # TODO: This is broken. Fallback case always triggers.
            while getopts ":m:p:h" opt; do
                case ${opt} in
                    m)
                        menu=true
                        ;;
                    p)
                        prompt="$OPTARG"
                        ;;
                    h)
                        usage
                        ;;
                    \?)
                        echo "Error: Invalid option: -$OPTARG"
                        usage
                        ;;
                    :)
                        echo "Error: Option -$OPTARG requires an argument"
                        usage
                        ;;
                esac
            done
            shift $((OPTIND - 1))
            OPTIND=1
            ;;

        *)
            echo "Error: Unknown argument: -$1"
            usage
            ;;
    esac
    shift
done

# Spawn a launcher menu
#-------------------------------------------------------------------------------

args=()

if [[ $LAUNCHER == "fuzzel" ]]; then
    args+=("-p" "$prompt")

    if [[ "$menu" = true ]]; then
        args+=("--dmenu")
    fi

elif [[ $LAUNCHER == "wofi" ]]; then
    args+=("-p" "$prompt")

    if [[ "$menu" = true ]]; then
        args+=("--show" "dmenu")
    else
        args+=("--show" "drun")
    fi

fi

"$LAUNCHER" "${args[@]}"
