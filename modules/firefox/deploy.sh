#-------------------------------------------------------------------------------
# Deploy firefox configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


firefox::install () {
    echo "└> Installing firefox configuration."

    local src="$base_dir/modules/firefox/src"

    ensure_directory "$XDG_DATA_HOME/applications"
    force_link "$src/firefox.desktop" "$XDG_DATA_HOME/applications/firefox.desktop"
}

firefox::uninstall () {
    echo "└> Uninstalling firefox configuration."

    rm -r "$XDG_DATA_HOME/applications/firefox.desktop"
}
