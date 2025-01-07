#-------------------------------------------------------------------------------
# Deploy system utility scripts
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")


scripts-system-utils::install () {
    echo "└> Installing system utility shortcuts."

    mkdir -p "$XDG_BIN_HOME"
    force_link "$base_dir/local/bin/logout" "$XDG_BIN_HOME/logout"
    force_link "$base_dir/local/bin/reboot" "$XDG_BIN_HOME/reboot"
    force_link "$base_dir/local/bin/shutdown" "$XDG_BIN_HOME/shutdown"
    force_link "$base_dir/local/bin/suspend" "$XDG_BIN_HOME/suspend"
}

scripts-system-utils::uninstall () {
    echo "└> Uninstalling system utility shortcuts."

    rm "$XDG_BIN_HOME/logout"
    rm "$XDG_BIN_HOME/reboot"
    rm "$XDG_BIN_HOME/shutdown"
    rm "$XDG_BIN_HOME/suspend"
}
