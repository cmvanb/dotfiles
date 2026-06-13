#-------------------------------------------------------------------------------
# Deploy pyenv configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/debug.sh"
source "$base_dir/lib/fs.sh"


pyenv::install () {
    debug::assert_dependency curl

    local src="$base_dir/modules/pyenv/src"

    if [[ ! -d $PYENV_ROOT ]]; then
        echo "└> Installing pyenv to \`$PYENV_ROOT\`."
        curl https://pyenv.run | bash

    else
        echo "└> Skipping pyenv; already installed."

    fi

    echo "└> Installing pyenv shell configuration."
    fs::force_link "$src/fish/pyenv.fish" "$XDG_CONFIG_HOME/fish/conf.d/pyenv.fish"
    fs::force_link "$src/bash/pyenv.sh" "$XDG_CONFIG_HOME/bash/conf.d/pyenv.sh"
}

pyenv::uninstall () {
    echo "└> Uninstalling pyenv."

    rm -rf "$PYENV_ROOT"
    rm -f "$XDG_CONFIG_HOME/fish/conf.d/pyenv.fish"
    rm -f "$XDG_CONFIG_HOME/bash/conf.d/pyenv.sh"
}
