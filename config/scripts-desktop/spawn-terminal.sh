#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Spawn a new terminal
#-------------------------------------------------------------------------------

command=""
cwd=""
floating=false

usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "    -c, --command COMMAND                Command to execute in the terminal."
    echo "    -d, --working-directory DIRECTORY    Directory to start the terminal in."
    echo "    -f, --floating                       Open terminal in floating mode."
    echo "    -h, --help                           Display this help message."
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

        --floating=*)
            echo "Error: --floating does not take arguments"
            usage
            ;;
        --floating)
            floating=true
            ;;

        --working-directory=*)
            cwd="${1#*=}"
            ;;
        --working-directory)
            if [ -n "$2" ]; then
                cwd="$2"
                return 2
            else
                echo "Error: --working-directory requires an argument"
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
            while getopts ":c:d:f:h" opt; do
                case ${opt} in
                    c)
                        command="$OPTARG"
                        ;;
                    d)
                        cwd="$OPTARG"
                        ;;
                    f)
                        floating=true
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

args=()

if [[ $TERMINAL == "alacritty" ]]; then
    if [[ "$floating" = true ]]; then
        args+=("--class=floating -o window.dimensions.columns=120 -o window.dimensions.lines=32")
    fi
    if [[ -n "$cwd" ]]; then
        args+=("--working-directory=$cwd")
    fi
    if [[ -n "$command" ]]; then
        args+=("--command=$SHELL -c $command")
    fi

    nohup alacritty "${args[@]}" > /dev/null 2>&1 &

elif [[ $TERMINAL == "ghostty" ]]; then
    if [[ "$floating" = true ]]; then
        args+=("--class=com.mitchellh.ghostty.floating")
    fi
    if [[ -n "$cwd" ]]; then
        args+=("--working-directory=$cwd")
    fi
    if [[ -n "$command" ]]; then
        args+=("--command=$SHELL -c $command")
    fi

    nohup ghostty "${args[@]}" > /dev/null 2>&1 &

elif [[ $TERMINAL == "wezterm" ]]; then
    if [[ "$floating" = true ]]; then
        args+=("--class=org.wezfurlong.wezterm.floating")
    fi
    if [[ -n "$cwd" ]]; then
        args+=("--cwd=$cwd")
    fi
    if [[ -n "$command" ]]; then
        # NOTE: Not sure why but the -e arguments must be passed as separate strings.
        args+=("-e" "$SHELL" "-c" "$command")
    fi

    nohup wezterm start "${args[@]}" > /dev/null 2>&1 &

else
    echo "Unsupported terminal emulator: $TERMINAL"
    exit 1
fi

exit 0
