#-------------------------------------------------------------------------------
# Deploy disable-xdg-desktop-files configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


    # TODO: Update to electron32.
disable-xdg-desktop-files::install () {
    echo "└> Installing disable-xdg-desktop-files configuration."

    force_link "$base_dir/config/disable-xdg-desktop-files/avahi-discover.desktop" "$XDG_DATA_HOME/applications/avahi-discover.desktop"
    force_link "$base_dir/config/disable-xdg-desktop-files/bssh.desktop" "$XDG_DATA_HOME/applications/bssh.desktop"
    force_link "$base_dir/config/disable-xdg-desktop-files/bvnc.desktop" "$XDG_DATA_HOME/applications/bvnc.desktop"
    force_link "$base_dir/config/disable-xdg-desktop-files/cmake-gui.desktop" "$XDG_DATA_HOME/applications/cmake-gui.desktop"
    force_link "$base_dir/config/disable-xdg-desktop-files/electron24.desktop" "$XDG_DATA_HOME/applications/electron24.desktop"
    force_link "$base_dir/config/disable-xdg-desktop-files/lstopo.desktop" "$XDG_DATA_HOME/applications/lstopo.desktop"
    force_link "$base_dir/config/disable-xdg-desktop-files/qv4l2.desktop" "$XDG_DATA_HOME/applications/qv4l2.desktop"
    force_link "$base_dir/config/disable-xdg-desktop-files/qvidcap.desktop" "$XDG_DATA_HOME/applications/qvidcap.desktop"
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
}
