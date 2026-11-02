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
    fs::force_link "$src/open-claude-cwd.sh" "$XDG_SCRIPTS_HOME/open-claude-cwd.sh"
    fs::force_link "$src/open-desktop-app.sh" "$XDG_SCRIPTS_HOME/open-desktop-app.sh"
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
    fs::force_link "$src/volume.sh" "$XDG_SCRIPTS_HOME/volume.sh"

    echo "└> Installing desktop shortcuts."

    fs::ensure_directory "$XDG_BIN_HOME"
    fs::force_link "$src/upload-to-0x0.sh" "$XDG_BIN_HOME/0x0"
    fs::force_link "$src/usb-disks.sh" "$XDG_BIN_HOME/usb"
}

scripts-desktop::uninstall () {
    echo "└> Uninstalling desktop scripts."

    fs::remove "$XDG_SCRIPTS_HOME/open-browser-session.sh"
    fs::remove "$XDG_SCRIPTS_HOME/open-claude-cwd.sh"
    fs::remove "$XDG_SCRIPTS_HOME/open-desktop-app.sh"
    fs::remove "$XDG_SCRIPTS_HOME/open-terminal-cwd.sh"
    fs::remove "$XDG_SCRIPTS_HOME/screenshot-rectangle.sh"
    fs::remove "$XDG_SCRIPTS_HOME/set-output-wallpaper.sh"
    fs::remove "$XDG_SCRIPTS_HOME/spawn-launcher.sh"
    fs::remove "$XDG_SCRIPTS_HOME/spawn-terminal.sh"
    fs::remove "$XDG_SCRIPTS_HOME/spawn.sh"
    fs::remove "$XDG_SCRIPTS_HOME/backup.sh"
    fs::remove "$XDG_SCRIPTS_HOME/upload-to-0x0.sh"
    fs::remove "$XDG_SCRIPTS_HOME/system-menu.sh"
    fs::remove "$XDG_SCRIPTS_HOME/usb-disks.sh"
    fs::remove "$XDG_SCRIPTS_HOME/volume.sh"

    echo "└> Uninstalling desktop shortcuts."

    fs::remove "$XDG_BIN_HOME/0x0"
    fs::remove "$XDG_BIN_HOME/usb"
}
