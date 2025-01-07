#-------------------------------------------------------------------------------
# Deploy disable-xdg-desktop-files configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


disable-xdg-desktop-files::install () {
    echo "└> Installing disable-xdg-desktop-files configuration."

    force_link "$base_dir/local/share/applications/avahi-discover.desktop" "$XDG_DATA_HOME/applications/avahi-discover.desktop"
    force_link "$base_dir/local/share/applications/bssh.desktop" "$XDG_DATA_HOME/applications/bssh.desktop"
    force_link "$base_dir/local/share/applications/bvnc.desktop" "$XDG_DATA_HOME/applications/bvnc.desktop"
    force_link "$base_dir/local/share/applications/cmake-gui.desktop" "$XDG_DATA_HOME/applications/cmake-gui.desktop"
    force_link "$base_dir/local/share/applications/electron24.desktop" "$XDG_DATA_HOME/applications/electron24.desktop"
    force_link "$base_dir/local/share/applications/lstopo.desktop" "$XDG_DATA_HOME/applications/lstopo.desktop"
    force_link "$base_dir/local/share/applications/qv4l2.desktop" "$XDG_DATA_HOME/applications/qv4l2.desktop"
    force_link "$base_dir/local/share/applications/qvidcap.desktop" "$XDG_DATA_HOME/applications/qvidcap.desktop"
    force_link "$base_dir/local/share/applications/vscodium.desktop" "$XDG_DATA_HOME/applications/vscodium.desktop"
}

disable-xdg-desktop-files::uninstall () {
    echo "└> Uninstalling disable-xdg-desktop-files configuration."

    rm "$XDG_DATA_HOME/applications/avahi-discover.desktop"
    rm "$XDG_DATA_HOME/applications/bssh.desktop"
    rm "$XDG_DATA_HOME/applications/bvnc.desktop"
    rm "$XDG_DATA_HOME/applications/cmake-gui.desktop"
    rm "$XDG_DATA_HOME/applications/electron24.desktop"
    rm "$XDG_DATA_HOME/applications/lstopo.desktop"
    rm "$XDG_DATA_HOME/applications/qv4l2.desktop"
    rm "$XDG_DATA_HOME/applications/qvidcap.desktop"
    rm "$XDG_DATA_HOME/applications/vscodium.desktop"
}
