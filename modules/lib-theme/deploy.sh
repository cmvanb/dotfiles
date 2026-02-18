#-------------------------------------------------------------------------------
# Deploy theme libraries
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


lib-theme::install () {
    echo "└> Installing theme libraries."

    local src="$base_dir/modules/lib-theme/src"

    ensure_directory "$XDG_OPT_HOME"
    force_link "$src" "$XDG_OPT_HOME/theme"
}

lib-theme::uninstall () {
    echo "└> Uninstalling theme libraries."

    rm -rf "$XDG_OPT_HOME/theme"
}
