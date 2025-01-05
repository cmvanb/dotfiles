#-------------------------------------------------------------------------------
# Deploy system utility scripts
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
bin_dir=${XDG_BIN_HOME:-$HOME/.local/bin}


scripts-system-utils::install () {
    echo "└> Installing system utility shortcuts."

    mkdir -p "$bin_dir"
    force_link "$base_dir/local/bin/logout" "$bin_dir/logout"
    force_link "$base_dir/local/bin/reboot" "$bin_dir/reboot"
    force_link "$base_dir/local/bin/shutdown" "$bin_dir/shutdown"
    force_link "$base_dir/local/bin/suspend" "$bin_dir/suspend"
}

scripts-system-utils::uninstall () {
    echo "└> Uninstalling system utility shortcuts."

    rm "$bin_dir/logout"
    rm "$bin_dir/reboot"
    rm "$bin_dir/shutdown"
    rm "$bin_dir/suspend"
}
