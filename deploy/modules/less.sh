#-------------------------------------------------------------------------------
# Deploy less configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


less::install () {
    echo "└> Installing less configuration."

    mkdir -p "$config_dir"
    force_link "$base_dir/config/lesskey" "$config_dir/lesskey"
}

less::uninstall () {
    echo "└> Uninstalling less configuration."

    rm "$config_dir/lesskey"
}
