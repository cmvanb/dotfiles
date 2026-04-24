#-------------------------------------------------------------------------------
# Deploy desktop scripts
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
source "$base_dir/lib/fs.sh"


scripts-desktop::install () {
    echo "└> Installing desktop scripts."

    local src="$base_dir/modules/scripts-desktop/src"

    fs::ensure_directory "$XDG_SCRIPTS_HOME"
    fs::force_link "$src/open-browser-session.sh" "$XDG_SCRIPTS_HOME/open-browser-session.sh"
    fs::force_link "$src/open-terminal-cwd.sh" "$XDG_SCRIPTS_HOME/open-terminal-cwd.sh"
    fs::force_link "$src/screenshot-rectangle.sh" "$XDG_SCRIPTS_HOME/screenshot-rectangle.sh"
    fs::force_link "$src/set-output-wallpaper.sh" "$XDG_SCRIPTS_HOME/set-output-wallpaper.sh"
    fs::force_link "$src/spawn-launcher.sh" "$XDG_SCRIPTS_HOME/spawn-launcher.sh"
    fs::force_link "$src/spawn-terminal.sh" "$XDG_SCRIPTS_HOME/spawn-terminal.sh"
    fs::force_link "$src/spawn.sh" "$XDG_SCRIPTS_HOME/spawn.sh"
    fs::force_link "$src/backup.sh" "$XDG_SCRIPTS_HOME/backup.sh"
    fs::force_link "$src/upload-to-0x0.sh" "$XDG_SCRIPTS_HOME/upload-to-0x0.sh"
    fs::force_link "$src/system-menu.sh" "$XDG_SCRIPTS_HOME/system-menu.sh"
    fs::force_link "$src/usb-disks.sh" "$XDG_SCRIPTS_HOME/usb-disks.sh"

    echo "└> Installing desktop shortcuts."

    fs::ensure_directory "$XDG_BIN_HOME"
    fs::force_link "$src/upload-to-0x0.sh" "$XDG_BIN_HOME/0x0"
    fs::force_link "$src/usb-disks.sh" "$XDG_BIN_HOME/usb"
}

scripts-desktop::uninstall () {
    echo "└> Uninstalling desktop scripts."

    rm "$XDG_SCRIPTS_HOME/open-browser-session.sh"
    rm "$XDG_SCRIPTS_HOME/open-terminal-cwd.sh"
    rm "$XDG_SCRIPTS_HOME/screenshot-rectangle.sh"
    rm "$XDG_SCRIPTS_HOME/set-output-wallpaper.sh"
    rm "$XDG_SCRIPTS_HOME/spawn-launcher.sh"
    rm "$XDG_SCRIPTS_HOME/spawn-terminal.sh"
    rm "$XDG_SCRIPTS_HOME/spawn.sh"
    rm "$XDG_SCRIPTS_HOME/backup.sh"
    rm "$XDG_SCRIPTS_HOME/upload-to-0x0.sh"
    rm "$XDG_SCRIPTS_HOME/system-menu.sh"
    rm "$XDG_SCRIPTS_HOME/usb-disks.sh"

    echo "└> Uninstalling desktop shortcuts."

    rm "$XDG_BIN_HOME/0x0"
    rm "$XDG_BIN_HOME/usb"
}
