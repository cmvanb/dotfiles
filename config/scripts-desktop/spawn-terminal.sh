#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Spawn a new terminal
#-------------------------------------------------------------------------------

command=""

usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -c, --command COMMAND    Command to execute in the terminal"
    echo "  -h, --help               Display this help message"
    exit 1
}

parse_long_options() {
    case "$1" in
        --command=*)
            command="${1#*=}"
            ;;

        --command)
            if [ -n "$2" ]; then
                command="$2"
                return 2
            else
                echo "Error: --command requires an argument"
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
            while getopts ":c:h" opt; do
                case ${opt} in
                    c)
                        command="$OPTARG"
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
            # If there are non-option arguments, add them to the command
            if [ -z "$command" ]; then
                command="$1"
            else
                command="$command $1"
            fi
            shift
            ;;
    esac
done

if [[ $TERMINAL == "alacritty" ]]; then
    if [ -n "$command" ]; then
        nohup alacritty -e "$SHELL" -c "$command" > /dev/null &

    else
        nohup alacritty > /dev/null &

    fi

elif [[ $TERMINAL == "ghostty" ]]; then
    if [ -n "$command" ]; then
        nohup ghostty -e "$SHELL" -c "$command" > /dev/null &

    else
        nohup ghostty > /dev/null &

    fi

elif [[ $TERMINAL == "wezterm" ]]; then
    if [ -n "$command" ]; then
        nohup wezterm start -- "$SHELL" -c "$command" > /dev/null &

    else
        nohup wezterm > /dev/null &

    fi

else
    echo "Unsupported terminal emulator: $TERMINAL"
    exit 1
fi

exit 0
