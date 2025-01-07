#-------------------------------------------------------------------------------
# Deploy vscodium configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/local/opt/shell-utils/fs.sh"


vscodium::install () {
    echo "└> Installing vscodium configuration."

    mkdir -p "$XDG_DATA_HOME/applications"
    force_link "$base_dir/local/share/applications/vscodium-wayland.desktop" "$XDG_DATA_HOME/applications/vscodium-wayland.desktop"
}

vscodium::uninstall () {
    echo "└> Uninstalling vscodium configuration."

    rm "$XDG_DATA_HOME/applications/vscodium-wayland.desktop"
}
