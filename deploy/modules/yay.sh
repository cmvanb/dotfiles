#-------------------------------------------------------------------------------
# Deploy yay configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


yay::install () {
    echo "└> Installing yay configuration."

    mkdir -p "$XDG_CONFIG_HOME/yay"
    force_link "$base_dir/config/yay/config.json" "$XDG_CONFIG_HOME/yay/config.json"
}

yay::uninstall () {
    echo "└> Uninstalling yay configuration."

    rm -r "$XDG_CONFIG_HOME/yay"
}
