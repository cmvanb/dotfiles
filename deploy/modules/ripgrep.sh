#-------------------------------------------------------------------------------
# Deploy ripgrep configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


ripgrep::install () {
    echo "└> Installing ripgrep configuration."

    ensure_directory "$XDG_CONFIG_HOME/ripgrep"
    esh "$base_dir/config/ripgrep/config~esh" > "$XDG_CONFIG_HOME/ripgrep/config"

    echo "└> Installing ripgrep shortcuts."

    ensure_directory "$XDG_BIN_HOME"
    force_link "$base_dir/config/ripgrep/ripgrep.sh" "$XDG_BIN_HOME/rg"
}

ripgrep::uninstall () {
    echo "└> Uninstalling ripgrep configuration."

    rm -r "$XDG_CONFIG_HOME/ripgrep"

    echo "└> Uninstalling ripgrep shortcuts."

    rm "$XDG_BIN_HOME/rg"
}
