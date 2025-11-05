#-------------------------------------------------------------------------------
# Deploy desktop scripts
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")


scripts-desktop::install () {
    echo "└> Installing desktop scripts."

    ensure_directory "$XDG_SCRIPTS_HOME"
    force_link "$base_dir/config/scripts-desktop/open-browser-session.sh" "$XDG_SCRIPTS_HOME/open-browser-session.sh"
    force_link "$base_dir/config/scripts-desktop/open-terminal-cwd.sh" "$XDG_SCRIPTS_HOME/open-terminal-cwd.sh"
    force_link "$base_dir/config/scripts-desktop/screenshot-rectangle.sh" "$XDG_SCRIPTS_HOME/screenshot-rectangle.sh"
    force_link "$base_dir/config/scripts-desktop/set-output-wallpaper.sh" "$XDG_SCRIPTS_HOME/set-output-wallpaper.sh"
    force_link "$base_dir/config/scripts-desktop/spawn-launcher.sh" "$XDG_SCRIPTS_HOME/spawn-launcher.sh"
    force_link "$base_dir/config/scripts-desktop/spawn-terminal.sh" "$XDG_SCRIPTS_HOME/spawn-terminal.sh"
    force_link "$base_dir/config/scripts-desktop/spawn.sh" "$XDG_SCRIPTS_HOME/spawn.sh"
    force_link "$base_dir/config/scripts-desktop/upload-to-0x0.sh" "$XDG_SCRIPTS_HOME/upload-to-0x0.sh"

    echo "└> Installing desktop shortcuts."

    ensure_directory "$XDG_BIN_HOME"
    force_link "$base_dir/config/scripts-desktop/upload-to-0x0.sh" "$XDG_BIN_HOME/0x0"
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
    rm "$XDG_SCRIPTS_HOME/upload-to-0x0.sh"

    echo "└> Uninstalling desktop shortcuts."

    rm "$XDG_BIN_HOME/0x0"
}
