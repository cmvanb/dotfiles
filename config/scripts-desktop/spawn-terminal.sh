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

        --title=*)
            title="${1#*=}"
            ;;
        --title)
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

parse_short_options() {
    local opt_string="$1"
    shift

    # Strip leading dash.
    opt_string="${opt_string#-}"

    while [ -n "$opt_string" ]; do
        local opt="${opt_string:0:1}"
        opt_string="${opt_string:1}"

        case "$opt" in
            c)
                # -ovalue format
                if [ -n "$opt_string" ]; then
                    command="$opt_string"
                    return 0
                # -o value format
                elif [ $# -gt 0 ]; then
                    command="$1"
                    return 1
                else
                    echo "Error: Option -c requires an argument"
                    usage
                fi
                ;;
            d)
                if [ -n "$opt_string" ]; then
                    cwd="$opt_string"
                    return 0
                elif [ $# -gt 0 ]; then
                    cwd="$1"
                    return 1
                else
                    echo "Error: Option -d requires an argument"
                    usage
                fi
                ;;
            f)
                floating=true
                ;;
            t)
                if [ -n "$opt_string" ]; then
                    title="$opt_string"
                    return 0
                elif [ $# -gt 0 ]; then
                    title="$1"
                    return 1
                else
                    echo "Error: Option -t requires an argument"
                    usage
                fi
                ;;
            h)
                usage
                ;;
            *)
                echo "Error: Invalid option: -$opt"
                usage
                ;;
        esac
    done
    return 0
}

while [ $# -gt 0 ]; do
    case "$1" in
        --*=*|--*)
            parse_long_options "$1" "${2:-}"
            shift $?
            ;;

        -*)
            parse_short_options "$@"
            consumed=$?
            shift $((consumed + 1))
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
