#-------------------------------------------------------------------------------
# Deploy chromium configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


chromium::install () {
    echo "└> Installing chromium configuration."

    local src="$base_dir/modules/chromium/src"

    ensure_directory "$XDG_DATA_HOME/applications"
    force_link "$src/chromium.desktop" "$XDG_DATA_HOME/applications/chromium.desktop"
}

chromium::uninstall () {
    echo "└> Uninstalling chromium configuration."

    rm "$XDG_DATA_HOME/applications/chromium.desktop"
}
