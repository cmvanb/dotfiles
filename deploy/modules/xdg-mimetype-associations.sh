#-------------------------------------------------------------------------------
# Deploy xdg-mimetype-associations configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/local/opt/shell-utils/fs.sh"


xdg-mimetype-associations::install () {
    echo "└> Installing xdg-mimetype-associations configuration."

    mkdir -p "$XDG_CONFIG_HOME"
    force_link "$base_dir/config/mimeapps.list" "$XDG_CONFIG_HOME/mimeapps.list"
}

xdg-mimetype-associations::uninstall () {
    echo "└> Uninstalling xdg-mimetype-associations configuration."

    rm "$XDG_CONFIG_HOME/mimeapps.list"
}
