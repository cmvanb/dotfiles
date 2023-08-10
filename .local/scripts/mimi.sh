#!/usr/bin/env bash
#---------------------------------------------------------------------------------------------------
# mimi file opener
#
# https://github.com/BachoSeven/mimi
#---------------------------------------------------------------------------------------------------

readonly CONFIG="$XDG_CONFIG_HOME/mimi/mimi.conf"

find_in_config() {
    [[ -f "$CONFIG" ]] || return
    grep -m 1 "^$1: " "$CONFIG" | cut -d ' ' -f 2-
}

need_terminal() {
    grep -m 1 -q '^Terminal=true$'
}

find_exec_in_desktop_file() {
    # accepts Exec entries with arguments
    grep '^Exec' "$@" | head -1 | sed 's/^Exec=//' | sed 's/%.//' | sed 's/^"//g' | sed 's/" *$//g'
}

find_desktop_file_in_path() {
    local path="$1"
    grep -m 1 "^$2=.*$3" -R "${path[@]}" | awk -F : -v pat="$3" '{ print index($2, pat), length($2), $1 }' | sort -t ' ' -k1,1n -k2,2nr | awk '{ print $3; exit }'
}

find_desktop_file_by() {
    local desktop="$(find_desktop_file_in_path "$XDG_DATA_HOME/applications" MimeType "$1")"

    if [[ -z $desktop ]]; then
        # TODO: Iterate over $XDG_DATA_DIRS instead of hardcoded path.
        desktop="$(find_desktop_file_in_path "/usr/share/applications" MimeType "$1")"
    fi

    echo $desktop
}

url_decode() {
    echo -e "$(sed 's/%\([a-f0-9A-F]\{2\}\)/\\x\1/g')"
}

run() {
    $SHELL -c "'$1' $(printf "%q " "${@:2}")"
}

fork_run() {
    # echo "'$1' $(printf "%q " "${@:2}")"
    if tty -s; then
        # in interactive mode, just run normally.
        run "$@"
    else
        run "$@" &
    fi
    exit 0
}

exists() {
    type "$@" &>/dev/null
}

usage() {
    cat <<-EOF
  Usage: mimi.sh [file|directory|protocol]
  
  It opens a file according to the extension
  To setup the extension, create $CONFIG
  
  mimi :)
EOF
    exit 1
}

# config
# 1. ext
# 2. protocol
# 3. mime
# 4. general mime
# .desktop (mime and general mime)
# 5. ask

[[ ! "$*" ]] && usage

arg="$*"
ext=''
protocol=''
mime=''
general_mime=''

# fix file:// with support for file://.html#section
if [[ "$arg" =~ ^file://([^#]*\.html)#.*$ ]]; then
    protocol=file
    mime=text/html
    ext=html
elif [[ "$arg" =~ ^file://(.*)$ ]]; then
    # strip file://
    arg="$(url_decode <<<"${BASH_REMATCH[1]}")"
    protocol=file
fi

if [[ -e "$arg" ]]; then
    # file or dir
    mime="$(file -b --mime-type "$(realpath "$arg")")"
    if [[ -f "$arg" ]]; then
        ext="$(tr '[:upper:]' '[:lower:]' <<< "${arg##*.}")"
    fi
else
    ext="$(tr '[:upper:]' '[:lower:]' <<< "${arg##*.}")"
    ext="$ext\$"
fi

# protocol to mime ext
if [[ "$arg" =~ ^([a-zA-Z-]+): ]]; then
    # use protocol to guess mime ext
    protocol="${BASH_REMATCH[1]}"
    case "$protocol" in
        http)
            mime=x-scheme-handler/http ;;
        https)
            mime=x-scheme-handler/https ;;
        magnet)
            mime=application/x-bittorrent
            ext=torrent ;;
        irc)
            mime=x-scheme-handler/irc ;;
        mailto)
            mime=x-scheme-handler/mailto ;;
        tg)
            mime=x-scheme-handler/tg ;;
        spotify)
            mime=x-scheme-handler/spotify ;;
        gemini)
            mime=x-scheme-handler/gemini ;;
        gopher)
            mime=x-scheme-handler/gopher ;;
        msteams)
            mime=x-scheme-handler/msteams ;;
        element)
            mime=x-scheme-handler/element ;;
        wza)
            mime=x-scheme-handler/wza ;;
    esac
    protocol="^$protocol"
fi

# executable with arguments
if [ ! "$mime" ] && [ -x "$1" ]; then
    mime="$(file -b --mime-type "$1")"
fi

# symlink
[ "$mime" = "inode/symlink" ] && mime="$(file -b --mime-type "$(realpath "$arg")")"

# application mime is specific
[[ "$mime" =~ ^(audio|image|text|video)/ ]] && general_mime="${BASH_REMATCH[1]}/"

CONFIG_TERM=$(find_in_config TERM)
if exists "$CONFIG_TERM"; then
    TERM="$CONFIG_TERM"
fi

ALT_MENU=$(find_in_config MENU)
if [[ -n "$ALT_MENU" ]]; then
    MENUARGS=$(find_in_config MENUARGS)
fi
MENU=${ALT_MENU:-dmenu}

# config
for search in $ext $protocol $mime $general_mime; do
    app=($(find_in_config "$search"))
    [[ "${app[0]}" == TERM ]] && exists "$TERM" && app[0]="$TERM"
    # handle environmental variables
    i=0
    for w in "${app[@]}"; do
        if [[ -n "$(echo "$w" | grep '^\$')" ]]; then
            program="$(echo "$w" | sed 's/^\$//')"
            app[$i]="$(env | grep "$program" | head -1 | cut -d = -f 2)"
        fi
        i=$((i+1));
    done
    [[ "${app[*]}" ]] && fork_run "${app[@]}" "$arg"
done

# .desktop
for search in $mime $general_mime; do
    desktop="$(find_desktop_file_by "$search")"
    if [[ "$desktop" ]]; then
        # echo "$desktop"
        app=($(find_exec_in_desktop_file <"$desktop"))
        if need_terminal <"$desktop"; then
            # echo "term: $TERM"
            exists "$TERM" && fork_run "$TERM" -e "${app[@]}" "$arg"
        else
            fork_run "${app[@]}" "$arg"
        fi
    fi
done

# ask
if exists $MENU; then
    app=($(IFS=:; stest -flx $PATH | sort -u | $MENU -p "how to open $(basename $arg)" $MENUARGS))
    [[ "${app[*]}" ]] && fork_run "${app[@]}" "$arg"
elif exists notify-send; then
    notify-send "Could not find opener, exiting..."
fi

