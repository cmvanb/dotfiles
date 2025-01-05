#-------------------------------------------------------------------------------
# Deploy vscodium configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
data_dir=${XDG_DATA_HOME:-$HOME/.local/share}

source "$base_dir/local/opt/shell-utils/fs.sh"


vscodium::install () {
    echo "└> Installing vscodium configuration."

    mkdir -p "$data_dir/applications"
    force_link "$base_dir/local/share/applications/vscodium-wayland.desktop" "$data_dir/applications/vscodium-wayland.desktop"
}

vscodium::uninstall () {
    echo "└> Uninstalling vscodium configuration."

    rm "$data_dir/applications/vscodium-wayland.desktop"
}
