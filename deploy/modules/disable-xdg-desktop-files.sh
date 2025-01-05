#-------------------------------------------------------------------------------
# Deploy disable-xdg-desktop-files configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
data_dir=${XDG_DATA_HOME:-$HOME/.local/share}

source "$base_dir/local/opt/shell-utils/fs.sh"


disable-xdg-desktop-files::install () {
    echo "└> Installing disable-xdg-desktop-files configuration."

    force_link "$base_dir/local/share/applications/avahi-discover.desktop" "$data_dir/applications/avahi-discover.desktop"
    force_link "$base_dir/local/share/applications/bssh.desktop" "$data_dir/applications/bssh.desktop"
    force_link "$base_dir/local/share/applications/bvnc.desktop" "$data_dir/applications/bvnc.desktop"
    force_link "$base_dir/local/share/applications/cmake-gui.desktop" "$data_dir/applications/cmake-gui.desktop"
    force_link "$base_dir/local/share/applications/electron24.desktop" "$data_dir/applications/electron24.desktop"
    force_link "$base_dir/local/share/applications/lstopo.desktop" "$data_dir/applications/lstopo.desktop"
    force_link "$base_dir/local/share/applications/qv4l2.desktop" "$data_dir/applications/qv4l2.desktop"
    force_link "$base_dir/local/share/applications/qvidcap.desktop" "$data_dir/applications/qvidcap.desktop"
    force_link "$base_dir/local/share/applications/vscodium.desktop" "$data_dir/applications/vscodium.desktop"
}

disable-xdg-desktop-files::uninstall () {
    echo "└> Uninstalling disable-xdg-desktop-files configuration."

    rm "$data_dir/applications/avahi-discover.desktop"
    rm "$data_dir/applications/bssh.desktop"
    rm "$data_dir/applications/bvnc.desktop"
    rm "$data_dir/applications/cmake-gui.desktop"
    rm "$data_dir/applications/electron24.desktop"
    rm "$data_dir/applications/lstopo.desktop"
    rm "$data_dir/applications/qv4l2.desktop"
    rm "$data_dir/applications/qvidcap.desktop"
    rm "$data_dir/applications/vscodium.desktop"
}
