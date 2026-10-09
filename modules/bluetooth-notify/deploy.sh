#-------------------------------------------------------------------------------
# Deploy bluetooth-notify configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


bluetooth-notify::install () {
    echo "└> Installing bluetooth-notify configuration."

    local src="$base_dir/modules/bluetooth-notify/src"

    fs::ensure_directory "$XDG_SCRIPTS_HOME"
    fs::force_link "$src/bluetooth-notify.sh" "$XDG_SCRIPTS_HOME/bluetooth-notify.sh"

    fs::ensure_directory "$XDG_CONFIG_HOME/systemd/user"
    fs::force_link "$src/bluetooth-notify.service" "$XDG_CONFIG_HOME/systemd/user/bluetooth-notify.service"
}

bluetooth-notify::uninstall () {
    echo "└> Uninstalling bluetooth-notify configuration."

    rm "$XDG_SCRIPTS_HOME/bluetooth-notify.sh"
    rm "$XDG_CONFIG_HOME/systemd/user/bluetooth-notify.service"
}

bluetooth-notify::enable () {
    echo "└> Enabling bluetooth-notify user service."

    systemctl --user enable bluetooth-notify
}

bluetooth-notify::disable () {
    echo "└> Disabling bluetooth-notify user service."

    systemctl --user disable bluetooth-notify
}
