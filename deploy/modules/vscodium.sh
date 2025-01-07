#-------------------------------------------------------------------------------
# Deploy vscodium configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


vscodium::install () {
    echo "└> Installing vscodium configuration."

    mkdir -p "$XDG_DATA_HOME/applications"
    force_link "$base_dir/config/vscodium/vscodium-wayland.desktop" "$XDG_DATA_HOME/applications/vscodium-wayland.desktop"
    force_link "$base_dir/config/vscodium/vscodium.desktop" "$XDG_DATA_HOME/applications/vscodium.desktop"
}

vscodium::uninstall () {
    echo "└> Uninstalling vscodium configuration."

    rm "$XDG_DATA_HOME/applications/vscodium-wayland.desktop"
    rm "$XDG_DATA_HOME/applications/vscodium.desktop"
}
