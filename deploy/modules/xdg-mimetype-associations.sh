#-------------------------------------------------------------------------------
# Deploy xdg-mimetype-associations configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


xdg-mimetype-associations::install () {
    echo "└> Installing xdg-mimetype-associations configuration."

    mkdir -p "$config_dir"
    force_link "$base_dir/config/mimeapps.list" "$config_dir/mimeapps.list"
}

xdg-mimetype-associations::uninstall () {
    echo "└> Uninstalling xdg-mimetype-associations configuration."

    rm "$config_dir/mimeapps.list"
}
