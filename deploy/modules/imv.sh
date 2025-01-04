#-------------------------------------------------------------------------------
# Deploy imv configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


imv::install () {
    echo "└> Installing imv configuration."

    force_link "$base_dir/config/imv" "$config_dir/imv"
}

imv::uninstall () {
    echo "└> Uninstalling imv configuration."

    rm "$config_dir/imv"
}
