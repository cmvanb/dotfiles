#-------------------------------------------------------------------------------
# Deploy imv configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


imv::install () {
    echo "└> Installing imv configuration."

    force_link "$base_dir/config/imv" "$XDG_CONFIG_HOME/imv"
}

imv::uninstall () {
    echo "└> Uninstalling imv configuration."

    rm "$XDG_CONFIG_HOME/imv"
}
