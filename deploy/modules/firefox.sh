#-------------------------------------------------------------------------------
# Deploy firefox configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


firefox::install () {
    echo "└> Installing firefox configuration."

    ensure_directory "$XDG_DATA_HOME/applications"
    force_link "$base_dir/config/firefox/firefox.desktop" "$XDG_DATA_HOME/applications/firefox.desktop"
}

firefox::uninstall () {
    echo "└> Uninstalling firefox configuration."

    rm -r "$XDG_DATA_HOME/applications/firefox.desktop"
}
