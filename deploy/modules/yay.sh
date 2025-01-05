#-------------------------------------------------------------------------------
# Deploy yay configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


yay::install () {
    echo "└> Installing yay configuration."

    if [[ $SYSTEM_DISTRO == "arch" ]]; then
        mkdir -p "$config_dir/yay"
        force_link "$base_dir/config/yay/config.json" "$config_dir/yay/config.json"
    fi
}

yay::uninstall () {
    echo "└> Uninstalling yay configuration."

    rm -r "$config_dir/yay"
}
