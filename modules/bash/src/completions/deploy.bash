_deploy_sh() {
    local cur prev subcommand dotfiles_dir script_path

    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    script_path=$(realpath "${COMP_WORDS[0]}" 2>/dev/null) || return 0
    dotfiles_dir=$(dirname "$script_path")

    if [[ "$COMP_CWORD" -eq 1 ]]; then
        COMPREPLY=( $(compgen -W "install uninstall list show status --help" -- "$cur") )
        return 0
    fi

    subcommand="${COMP_WORDS[1]}"

    # List subdirectory names (modules are dirs)
    _deploy_dirs() {
        local f p
        for f in "$1"/*/; do
            p="${f%/}"; [[ -d "$p" ]] && printf '%s\n' "${p##*/}"
        done
    }
    # List file names (profiles are files)
    _deploy_files() {
        local f
        for f in "$1"/*; do
            [[ -f "$f" ]] && printf '%s\n' "${f##*/}"
        done
    }

    case "$subcommand" in
        install)
            local choices
            choices=$({ _deploy_dirs "$dotfiles_dir/modules"; _deploy_files "$dotfiles_dir/profiles"; printf '%s\n' --dry-run --host; } | sort -u)
            COMPREPLY=( $(compgen -W "$choices" -- "$cur") )
            ;;
        uninstall)
            if [[ "$COMP_CWORD" -eq 2 ]]; then
                local choices
                choices=$({ _deploy_dirs "$dotfiles_dir/modules"; _deploy_files "$dotfiles_dir/profiles"; } | sort -u)
                COMPREPLY=( $(compgen -W "$choices" -- "$cur") )
            fi
            ;;
        show)
            if [[ "$COMP_CWORD" -eq 2 ]]; then
                local choices
                choices=$(_deploy_files "$dotfiles_dir/profiles" | sort -u)
                COMPREPLY=( $(compgen -W "$choices" -- "$cur") )
            fi
            ;;
    esac
}

complete -F _deploy_sh deploy.sh ./deploy.sh
