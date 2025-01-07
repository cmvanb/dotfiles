#-------------------------------------------------------------------------------
# Deploy desktop scripts
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")


scripts-desktop::install () {
    echo "└> Installing desktop scripts."

    mkdir -p "$XDG_SCRIPTS_HOME"
    force_link "$base_dir/local/scripts/lock-screen.sh" "$XDG_SCRIPTS_HOME/lock-screen.sh"
    force_link "$base_dir/local/scripts/open-terminal-cwd.sh" "$XDG_SCRIPTS_HOME/open-terminal-cwd.sh"
    force_link "$base_dir/local/scripts/set-output-wallpaper.sh" "$XDG_SCRIPTS_HOME/set-output-wallpaper.sh"
    force_link "$base_dir/local/scripts/screenshot-rectangle.sh" "$XDG_SCRIPTS_HOME/screenshot-rectangle.sh"

    echo "└> Installing desktop shortcuts."

    # TODO: Give this script a better name.
    mkdir -p "$XDG_BIN_HOME"
    force_link "$base_dir/local/bin/0x0" "$XDG_BIN_HOME/0x0"
}

scripts-desktop::uninstall () {
    echo "└> Uninstalling desktop scripts."

    rm "$XDG_SCRIPTS_HOME/lock-screen.sh"
    rm "$XDG_SCRIPTS_HOME/open-terminal-cwd.sh"
    rm "$XDG_SCRIPTS_HOME/set-output-wallpaper.sh"
    rm "$XDG_SCRIPTS_HOME/screenshot-rectangle.sh"

    echo "└> Uninstalling desktop shortcuts."

    rm "$XDG_BIN_HOME/0x0"
}
