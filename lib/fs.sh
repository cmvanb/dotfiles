#-------------------------------------------------------------------------------
# Bash file system utilities
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/debug.sh"

fs::get_script_dir () {
    # Get the directory of the script that is calling this function.
    cd -- "$( dirname -- "${BASH_SOURCE[1]}" )" &> /dev/null && pwd
}

fs::ensure_directory () {
    if [[ -z "$1" ]]; then
        debug::error "Missing argument: directory"
        return 1
    fi

    # Delete pre-existing links and files.
    if [[ -L "$1" ]] || [[ -f "$1" ]]; then
        rm "$1"
    fi

    if [[ ! -d "$1" ]]; then
        mkdir -p "$1"
    fi
}

fs::same_file() {
    if [[ -z "$1" || -z "$2" ]]; then
        debug::error "Missing argument: file1 file2"
        return 1
    fi

    if [[ ! -f "$1" || ! -f "$2" ]]; then
        debug::error "Arguments must be files"
        return 1
    fi
    if [[ "$1" -ef "$2" ]]; then
        return 0
    fi
    return 1
}

fs::force_link () {
    if [[ -z "$1" ]]; then
        debug::error "Missing argument: target"
        return 1
    fi
    if [[ -z "$2" ]]; then
        debug::error "Missing argument: link name"
        return 1
    fi
    if [[ ! -f "$1" && ! -d "$1" ]]; then
        debug::error "Tried to link non-existent \`$1\`"
        return 1
    fi

    # Delete pre-existing directory if we are trying to link it.
    if [[ -d "$2" ]]; then
        rm -r "$2"
    fi

    ln -sfT "$1" "$2"
}

fs::force_copy () {
    if [[ -z "$1" ]]; then
        debug::error "Missing argument: source"
        return 1
    fi
    if [[ -z "$2" ]]; then
        debug::error "Missing argument: destination"
        return 1
    fi
    if [[ ! -f "$1" && ! -d "$1" ]]; then
        debug::error "Tried to copy non-existent \`$1\`"
        return 1
    fi

    # Delete pre-existing link
    if [[ -L "$2" ]]; then
        rm "$2"
    fi

    cp -rfT "$1" "$2"
}

fs::happy_move() {
    # NOTE: `mv` returns an error code if the source and destination are the
    # same, so exit early with a success code.
    if [[ "$1" == "$2" ]]; then
        return 0
    fi

    mv "$1" "$2"
}

fs::file_mime_type () {
    if [[ -z "$1" ]]; then
        debug::error "Missing argument: file name"
        return 1
    fi

    if [[ ! -f "$1" ]]; then
        debug::error "Argument is not a file"
        return 1
    fi

    file -L -b --mime-type "$1"
}

fs::file_encoding () {
    if [[ -z "$1" ]]; then
        debug::error "Missing argument: file name"
        return 1
    fi

    if [[ ! -f "$1" ]]; then
        debug::error "Argument is not a file"
        return 1
    fi

    file -L -b --mime-encoding "$1"
}

fs::file_is_binary () {
    encoding=$(fs::file_encoding "$1")

    if [[ $encoding == "binary" ]]; then
        return 0
    fi

    return 1
}

fs::file_extension () {
    if [[ -z "$1" ]]; then
        debug::error "Missing argument: file name"
        return 1
    fi

    if [[ ! -f "$1" ]]; then
        debug::error "Argument is not a file"
        return 1
    fi

    echo "${1##*.}"
}
