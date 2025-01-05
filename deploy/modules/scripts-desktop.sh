#-------------------------------------------------------------------------------
# Deploy desktop scripts
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
scripts_dir=${XDG_SCRIPTS_HOME:-$HOME/.local/scripts}
bin_dir=${XDG_BIN_HOME:-$HOME/.local/bin}


scripts-desktop::install () {
    echo "└> Installing desktop scripts."

    mkdir -p "$scripts_dir"
    force_link "$base_dir/local/scripts/lock-screen.sh" "$scripts_dir/lock-screen.sh"
    force_link "$base_dir/local/scripts/open-terminal-cwd.sh" "$scripts_dir/open-terminal-cwd.sh"
    force_link "$base_dir/local/scripts/set-output-wallpaper.sh" "$scripts_dir/set-output-wallpaper.sh"
    force_link "$base_dir/local/scripts/screenshot-rectangle.sh" "$scripts_dir/screenshot-rectangle.sh"

    echo "└> Installing desktop shortcuts."

    # TODO: Give this script a better name.
    mkdir -p "$bin_dir"
    force_link "$base_dir/local/bin/0x0" "$bin_dir/0x0"
}

scripts-desktop::uninstall () {
    echo "└> Uninstalling desktop scripts."

    rm "$scripts_dir/lock-screen.sh"
    rm "$scripts_dir/open-terminal-cwd.sh"
    rm "$scripts_dir/set-output-wallpaper.sh"
    rm "$scripts_dir/screenshot-rectangle.sh"

    echo "└> Uninstalling desktop shortcuts."

    rm "$bin_dir/0x0"
}
