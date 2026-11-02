#-------------------------------------------------------------------------------
# Deploy system utility scripts
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
source "$base_dir/lib/fs.sh"


scripts-system-utils::install () {
    echo "└> Installing system utility shortcuts."

    local src="$base_dir/modules/scripts-system-utils/src"

    fs::ensure_directory "$XDG_BIN_HOME"
    fs::force_link "$src/init.basic" "$XDG_BIN_HOME/init"
    fs::force_link "$src/logout.sh" "$XDG_BIN_HOME/logout"
    fs::force_link "$src/reboot.sh" "$XDG_BIN_HOME/reboot"
    fs::force_link "$src/reboot-windows.sh" "$XDG_BIN_HOME/windows"
    fs::force_link "$src/windows-entry.sh" "$XDG_BIN_HOME/windows-entry"
    fs::force_link "$src/shutdown.sh" "$XDG_BIN_HOME/shutdown"
    fs::force_link "$src/suspend.sh" "$XDG_BIN_HOME/suspend"
}

scripts-system-utils::uninstall () {
    echo "└> Uninstalling system utility shortcuts."

    local src="$base_dir/modules/scripts-system-utils/src"

    if fs::same_file "$XDG_BIN_HOME/init" "$src/init.basic"; then
        fs::remove "$XDG_BIN_HOME/init"
    fi
    fs::remove "$XDG_BIN_HOME/logout"
    fs::remove "$XDG_BIN_HOME/reboot"
    fs::remove "$XDG_BIN_HOME/windows"
    fs::remove "$XDG_BIN_HOME/windows-entry"
    fs::remove "$XDG_BIN_HOME/shutdown"
    fs::remove "$XDG_BIN_HOME/suspend"
}
