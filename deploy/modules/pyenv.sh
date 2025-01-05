#-------------------------------------------------------------------------------
# Deploy pyenv configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/local/opt/shell-utils/debug.sh"


pyenv::install () {
    assert_dependency curl

    if [[ ! -d $PYENV_ROOT ]]; then
        echo "└> Installing pyenv to \`$PYENV_ROOT\`."
        curl https://pyenv.run | bash

    else
        echo "└> Not installing pyenv to \`$PYENV_ROOT\`; directory already exists."

    fi
}

pyenv::uninstall () {
    echo "└> Uninstalling pyenv configuration."

    rm -r "$PYENV_ROOT"
}
