export PYENV_ROOT="$XDG_OPT_HOME/pyenv"
path_prepend "$PYENV_ROOT/bin"

if command -v pyenv &> /dev/null; then
    eval "$(pyenv init -)"
fi
