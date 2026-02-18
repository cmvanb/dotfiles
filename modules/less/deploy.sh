#-------------------------------------------------------------------------------
# Deploy less configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


less::install () {
    echo "└> Installing less configuration."

    local src="$base_dir/modules/less/src"

    ensure_directory "$XDG_CONFIG_HOME"
    force_link "$src/lesskey" "$XDG_CONFIG_HOME/lesskey"
}

less::uninstall () {
    echo "└> Uninstalling less configuration."

    rm "$XDG_CONFIG_HOME/lesskey"
}
