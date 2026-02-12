fish_add_path -pP "$XDG_DATA_HOME/fnm"

if status is-interactive
and command -v fnm >/dev/null
    fnm env --use-on-cd --shell fish | source
end
