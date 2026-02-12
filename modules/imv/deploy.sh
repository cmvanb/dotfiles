#-------------------------------------------------------------------------------
# Deploy imv configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/modules/lib-shell-utils/src/fs.sh"


imv::install () {
    echo "└> Installing imv configuration."

    local src="$base_dir/modules/imv/src"

    force_link "$src" "$XDG_CONFIG_HOME/imv"
}

imv::uninstall () {
    echo "└> Uninstalling imv configuration."

    rm "$XDG_CONFIG_HOME/imv"
}
