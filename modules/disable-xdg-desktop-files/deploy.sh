#-------------------------------------------------------------------------------
# Deploy disable-xdg-desktop-files configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


disable-xdg-desktop-files::install () {
    echo "└> Installing disable-xdg-desktop-files configuration."

    local src="$base_dir/modules/disable-xdg-desktop-files/src"

    fs::force_link "$src/avahi-discover.desktop" "$XDG_DATA_HOME/applications/avahi-discover.desktop"
    fs::force_link "$src/bssh.desktop" "$XDG_DATA_HOME/applications/bssh.desktop"
    fs::force_link "$src/bvnc.desktop" "$XDG_DATA_HOME/applications/bvnc.desktop"
    fs::force_link "$src/cmake-gui.desktop" "$XDG_DATA_HOME/applications/cmake-gui.desktop"
    fs::force_link "$src/electron36.desktop" "$XDG_DATA_HOME/applications/electron36.desktop"
    fs::force_link "$src/lstopo.desktop" "$XDG_DATA_HOME/applications/lstopo.desktop"
    fs::force_link "$src/jconsole-java-openjdk.desktop" "$XDG_DATA_HOME/applications/jconsole-java-openjdk.desktop"
    fs::force_link "$src/jshell-java-openjdk.desktop" "$XDG_DATA_HOME/applications/jshell-java-openjdk.desktop"
    fs::force_link "$src/qv4l2.desktop" "$XDG_DATA_HOME/applications/qv4l2.desktop"
    fs::force_link "$src/qvidcap.desktop" "$XDG_DATA_HOME/applications/qvidcap.desktop"
}

disable-xdg-desktop-files::uninstall () {
    echo "└> Uninstalling disable-xdg-desktop-files configuration."

    rm "$XDG_DATA_HOME/applications/avahi-discover.desktop"
    rm "$XDG_DATA_HOME/applications/bssh.desktop"
    rm "$XDG_DATA_HOME/applications/bvnc.desktop"
    rm "$XDG_DATA_HOME/applications/cmake-gui.desktop"
    rm "$XDG_DATA_HOME/applications/electron36.desktop"
    rm "$XDG_DATA_HOME/applications/lstopo.desktop"
    rm "$XDG_DATA_HOME/applications/jconsole-java-openjdk.desktop"
    rm "$XDG_DATA_HOME/applications/jshell-java-openjdk.desktop"
    rm "$XDG_DATA_HOME/applications/qv4l2.desktop"
    rm "$XDG_DATA_HOME/applications/qvidcap.desktop"
}
