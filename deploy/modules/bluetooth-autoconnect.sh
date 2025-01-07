#-------------------------------------------------------------------------------
# Deploy bluetooth-autoconnect configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


bluetooth-autoconnect::install () {
    echo "└> Installing bluetooth-autoconnect configuration."

    mkdir -p "$XDG_CONFIG_HOME/systemd/user"
    force_link "$base_dir/config/systemd/user/bluetooth-autoconnect.service" "$XDG_CONFIG_HOME/systemd/user/bluetooth-autoconnect.service"
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
