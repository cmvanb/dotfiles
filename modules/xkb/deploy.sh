#-------------------------------------------------------------------------------
# Deploy xkb (libxkbcommon user keymap) configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


xkb::install () {
    echo "└> Installing xkb configuration."

    local src="$base_dir/modules/xkb/src"

    fs::force_link "$src" "$XDG_CONFIG_HOME/xkb"
}

xkb::uninstall () {
    echo "└> Uninstalling xkb configuration."

    rm "$XDG_CONFIG_HOME/xkb"
}
