#-------------------------------------------------------------------------------
# Deploy xdg-mimetype-associations configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/modules/lib-shell-utils/src/fs.sh"


xdg-mimetype-associations::install () {
    echo "└> Installing xdg-mimetype-associations configuration."

    local src="$base_dir/modules/xdg-mimetype-associations/src"

    ensure_directory "$XDG_CONFIG_HOME"
    force_link "$src/mimeapps.list" "$XDG_CONFIG_HOME/mimeapps.list"
}

xdg-mimetype-associations::uninstall () {
    echo "└> Uninstalling xdg-mimetype-associations configuration."

    rm "$XDG_CONFIG_HOME/mimeapps.list"
}
