#-------------------------------------------------------------------------------
# Deploy ripgrep configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
bin_dir=${XDG_BIN_HOME:-$HOME/.local/bin}

source "$base_dir/local/opt/shell-utils/fs.sh"


ripgrep::install () {
    echo "└> Installing ripgrep configuration."

    mkdir -p "$config_dir/ripgrep"
    esh "$base_dir/config/ripgrep/config~esh" > "$config_dir/ripgrep/config"

    echo "└> Installing ripgrep shortcuts."

    force_link "$base_dir/local/bin/rg" "$bin_dir/rg"
}

ripgrep::uninstall () {
    echo "└> Uninstalling ripgrep configuration."

    rm -r "$config_dir/ripgrep"

    echo "└> Uninstalling ripgrep shortcuts."

    rm "$bin_dir/rg"
}
