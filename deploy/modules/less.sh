#-------------------------------------------------------------------------------
# Deploy less configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


less::install () {
    echo "└> Installing less configuration."

    mkdir -p "$XDG_CONFIG_HOME"
    force_link "$base_dir/config/lesskey" "$XDG_CONFIG_HOME/lesskey"
}

less::uninstall () {
    echo "└> Uninstalling less configuration."

    rm "$XDG_CONFIG_HOME/lesskey"
}
