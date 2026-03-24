#-------------------------------------------------------------------------------
# Deploy Python utility libraries
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

lib-python-utils::install () {
    echo "└> Installing Python utility libraries."

    local src="$base_dir/modules/lib-python-utils/src"
    local venv_dir="${XDG_OPT_HOME:-$HOME/.local/opt}/python-utils"
    local bin_dir="${XDG_BIN_HOME:-$HOME/.local/bin}"

    python -m venv "$venv_dir"
    "$venv_dir/bin/pip" install --quiet setuptools
    "$venv_dir/bin/pip" install --quiet -e "$src"

    mkdir -p "$bin_dir"
    ln -sf "$venv_dir/bin/render-mako" "$bin_dir/render-mako"
}

lib-python-utils::uninstall () {
    echo "└> Uninstalling Python utility libraries."

    local venv_dir="${XDG_OPT_HOME:-$HOME/.local/opt}/python-utils"
    local bin_dir="${XDG_BIN_HOME:-$HOME/.local/bin}"

    rm -f "$bin_dir/render-mako"
    rm -rf "$venv_dir"
}
