#-------------------------------------------------------------------------------
# Deploy wayland utility libraries
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
opt_dir=${XDG_OPT_HOME:-$HOME/.local/opt}

source "$base_dir/local/opt/shell-utils/fs.sh"


lib-wayland-utils::install () {
    echo "└> Installing wayland utility libraries."

    mkdir -p "$opt_dir"
    force_link "$base_dir/local/opt/wayland-utils" "$opt_dir/wayland-utils"
}

lib-wayland-utils::uninstall () {
    echo "└> Uninstalling wayland utility libraries."

    rm -rf "$opt_dir/wayland-utils"
}
