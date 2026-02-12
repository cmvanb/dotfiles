#-------------------------------------------------------------------------------
# Deploy ripgrep configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/modules/lib-shell-utils/src/fs.sh"


ripgrep::install () {
    echo "└> Installing ripgrep configuration."

    local src="$base_dir/modules/ripgrep/src"

    ensure_directory "$XDG_CONFIG_HOME/ripgrep"
    esh "$src/config~esh" > "$XDG_CONFIG_HOME/ripgrep/config"

    echo "└> Installing ripgrep shortcuts."

    ensure_directory "$XDG_BIN_HOME"
    force_link "$src/ripgrep.sh" "$XDG_BIN_HOME/rg"
}

ripgrep::uninstall () {
    echo "└> Uninstalling ripgrep configuration."

    rm -r "$XDG_CONFIG_HOME/ripgrep"

    echo "└> Uninstalling ripgrep shortcuts."

    rm "$XDG_BIN_HOME/rg"
}
