#-------------------------------------------------------------------------------
# Deploy yay configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


yay::install () {
    echo "└> Installing yay configuration."

    local src="$base_dir/modules/yay/src"

    ensure_directory "$XDG_CONFIG_HOME/yay"
    force_link "$src/config.json" "$XDG_CONFIG_HOME/yay/config.json"
}

yay::uninstall () {
    echo "└> Uninstalling yay configuration."

    rm -r "$XDG_CONFIG_HOME/yay"
}
