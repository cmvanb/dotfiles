#-------------------------------------------------------------------------------
# Deploy less configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


less::install () {
    echo "└> Installing less configuration."

    local src="$base_dir/modules/less/src"

    fs::ensure_directory "$XDG_CONFIG_HOME"
    fs::force_link "$src/lesskey"        "$XDG_CONFIG_HOME/lesskey"
    fs::force_link "$src/bash/less.sh"   "$XDG_CONFIG_HOME/bash/conf.d/less.sh"
    fs::force_link "$src/fish/less.fish" "$XDG_CONFIG_HOME/fish/conf.d/less.fish"
}

less::uninstall () {
    echo "└> Uninstalling less configuration."

    rm "$XDG_CONFIG_HOME/lesskey"
    rm -f "$XDG_CONFIG_HOME/bash/conf.d/less.sh"
    rm -f "$XDG_CONFIG_HOME/fish/conf.d/less.fish"
}
