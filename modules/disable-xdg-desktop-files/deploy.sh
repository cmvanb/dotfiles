#-------------------------------------------------------------------------------
# Deploy disable-xdg-desktop-files configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/modules/lib-shell-utils/src/fs.sh"


    # TODO: Update to electron32.
disable-xdg-desktop-files::install () {
    echo "└> Installing disable-xdg-desktop-files configuration."

    local src="$base_dir/modules/disable-xdg-desktop-files/src"

    force_link "$src/avahi-discover.desktop" "$XDG_DATA_HOME/applications/avahi-discover.desktop"
    force_link "$src/bssh.desktop" "$XDG_DATA_HOME/applications/bssh.desktop"
    force_link "$src/bvnc.desktop" "$XDG_DATA_HOME/applications/bvnc.desktop"
    force_link "$src/cmake-gui.desktop" "$XDG_DATA_HOME/applications/cmake-gui.desktop"
    force_link "$src/electron24.desktop" "$XDG_DATA_HOME/applications/electron24.desktop"
    force_link "$src/lstopo.desktop" "$XDG_DATA_HOME/applications/lstopo.desktop"
    force_link "$src/qv4l2.desktop" "$XDG_DATA_HOME/applications/qv4l2.desktop"
    force_link "$src/qvidcap.desktop" "$XDG_DATA_HOME/applications/qvidcap.desktop"
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
