#-------------------------------------------------------------------------------
# Deploy bluetooth-autoconnect configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/modules/lib-shell-utils/src/fs.sh"


bluetooth-autoconnect::install () {
    echo "└> Installing bluetooth-autoconnect configuration."

    local src="$base_dir/modules/bluetooth-autoconnect/src"

    ensure_directory "$XDG_CONFIG_HOME/systemd/user"
    force_link "$src/bluetooth-autoconnect.service" "$XDG_CONFIG_HOME/systemd/user/bluetooth-autoconnect.service"
}

bluetooth-autoconnect::uninstall () {
    echo "└> Uninstalling bluetooth-autoconnect configuration."

    rm "$XDG_CONFIG_HOME/systemd/user/bluetooth-autoconnect.service"
}

bluetooth-autoconnect::enable () {
    echo "└> Enabling bluetooth-autoconnect user service."

    systemctl --user enable bluetooth-autoconnect
}

bluetooth-autoconnect::disable () {
    echo "└> Disabling bluetooth-autoconnect user service."

    systemctl --user disable bluetooth-autoconnect
}
