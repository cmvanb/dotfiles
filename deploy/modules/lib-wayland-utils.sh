#-------------------------------------------------------------------------------
# Deploy wayland utility libraries
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


lib-wayland-utils::install () {
    echo "└> Installing wayland utility libraries."

    mkdir -p "$XDG_OPT_HOME"
    force_link "$base_dir/config/lib-wayland-utils" "$XDG_OPT_HOME/wayland-utils"
}

lib-wayland-utils::uninstall () {
    echo "└> Uninstalling wayland utility libraries."

    rm -rf "$XDG_OPT_HOME/wayland-utils"
}
