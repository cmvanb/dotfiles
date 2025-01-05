#-------------------------------------------------------------------------------
# Deploy chromium configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
data_dir=${XDG_DATA_HOME:-$HOME/.local/share}

source "$base_dir/local/opt/shell-utils/fs.sh"


chromium::install () {
    echo "└> Installing chromium configuration."

    mkdir -p "$data_dir/applications"
    force_link "$base_dir/local/share/applications/chromium.desktop" "$data_dir/applications/chromium.desktop"
}

chromium::uninstall () {
    echo "└> Uninstalling chromium configuration."

    rm "$data_dir/applications/chromium.desktop"
}
