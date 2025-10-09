#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Spawn a new terminal
#-------------------------------------------------------------------------------

command=""
cwd=""
floating=false
title=""

usage() {
    echo "$(basename "$0") [options]"
    echo "Options:"
    echo "    -c, --command COMMAND                Command to execute in the terminal."
    echo "    -d, --working-directory DIRECTORY    Directory to start the terminal in."
    echo "    -f, --floating                       Open terminal in floating mode."
    echo "    -t, --title TITLE                    Set the terminal window title."
    echo "    -h, --help                           Display this help message."
    exit 1
}

parse_long_options() {
    case "$1" in
        --command=*)
            command="${1#*=}"
            ;;
        --command)
            # TODO: This is broken. Equals sign required for now.
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
            # TODO: This is broken. Equals sign required for now.
            if [ -n "$2" ]; then
                cwd="$2"
                return 2
            else
                echo "Error: --working-directory requires an argument"
                usage
            fi
            ;;

        --title=*)
            title="${1#*=}"
            ;;
        --title)
            # TODO: This is broken. Equals sign required for now.
            if [ -n "$2" ]; then
                title="$2"
                return 2
            else
                echo "Error: --title requires an argument"
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
            while getopts ":c:d:f:t:h" opt; do
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
                    t)
                        title="$OPTARG"
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
terminal_cmd=()

if [[ $TERMINAL == "alacritty" ]]; then
    terminal_cmd=("alacritty")

    if [[ "$floating" = true ]]; then
        args+=("--class=floating")
        args+=("-o window.dimensions.columns=120")
        args+=("-o window.dimensions.lines=32")
    fi
    if [[ -n "$cwd" ]]; then
        args+=("--working-directory=$cwd")
    fi
    if [[ -n "$title" ]]; then
        args+=("--title=$title")
    fi
    if [[ -n "$command" ]]; then
        args+=("--command" "$SHELL" "-c" "$command")
    fi

elif [[ $TERMINAL == "ghostty" ]]; then
    terminal_cmd=("ghostty")

    if [[ "$floating" = true ]]; then
        args+=("--class=com.mitchellh.ghostty.floating")
    fi
    if [[ -n "$cwd" ]]; then
        args+=("--working-directory=$cwd")
    fi
    if [[ -n "$title" ]]; then
        args+=("--title=$title")
    fi
    if [[ -n "$command" ]]; then
        args+=("--command" "$SHELL" "-c" "$command")
    fi

elif [[ $TERMINAL == "wezterm" ]]; then
    terminal_cmd=("wezterm" "start")

    if [[ "$floating" = true ]]; then
        args+=("--class=org.wezfurlong.wezterm.floating")
    fi
    if [[ -n "$cwd" ]]; then
        args+=("--cwd=$cwd")
    fi
    if [[ -n "$title" ]]; then
        args+=("--title=$title")
    fi
    if [[ -n "$command" ]]; then
        args+=("-e" "$SHELL" "-c" "$command")
    fi

else
    echo "Unsupported terminal emulator: $TERMINAL"
    exit 1
fi

nohup "${terminal_cmd[@]}" "${args[@]}" >/dev/null 2>&1 &

exit 0
