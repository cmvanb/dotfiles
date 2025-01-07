#-------------------------------------------------------------------------------
# Deploy shell utility libraries
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


lib-shell-utils::install () {
    echo "└> Installing shell utility libraries."

    ensure_directory "$XDG_OPT_HOME"
    force_link "$base_dir/config/lib-shell-utils" "$XDG_OPT_HOME/shell-utils"
}

lib-shell-utils::uninstall () {
    echo "└> Uninstalling shell utility libraries."

    rm -rf "$XDG_OPT_HOME/shell-utils"
}
