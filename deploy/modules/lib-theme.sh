#-------------------------------------------------------------------------------
# Deploy theme libraries
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


lib-theme::install () {
    echo "└> Installing theme libraries."

    mkdir -p "$XDG_OPT_HOME"
    force_link "$base_dir/local/opt/theme" "$XDG_OPT_HOME/theme"
}

lib-theme::uninstall () {
    echo "└> Uninstalling theme libraries."

    rm -rf "$XDG_OPT_HOME/theme"
}
