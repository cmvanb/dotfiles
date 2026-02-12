#-------------------------------------------------------------------------------
# Deploy wayland utility libraries
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/modules/lib-shell-utils/src/fs.sh"


lib-wayland-utils::install () {
    echo "└> Installing wayland utility libraries."

    local src="$base_dir/modules/lib-wayland-utils/src"

    ensure_directory "$XDG_OPT_HOME"
    force_link "$src" "$XDG_OPT_HOME/wayland-utils"
}

lib-wayland-utils::uninstall () {
    echo "└> Uninstalling wayland utility libraries."

    rm -rf "$XDG_OPT_HOME/wayland-utils"
}
