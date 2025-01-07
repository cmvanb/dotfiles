#-------------------------------------------------------------------------------
# Deploy chromium configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/local/opt/shell-utils/fs.sh"


chromium::install () {
    echo "└> Installing chromium configuration."

    mkdir -p "$XDG_DATA_HOME/applications"
    force_link "$base_dir/local/share/applications/chromium.desktop" "$XDG_DATA_HOME/applications/chromium.desktop"
}

chromium::uninstall () {
    echo "└> Uninstalling chromium configuration."

    rm "$XDG_DATA_HOME/applications/chromium.desktop"
}
