#-------------------------------------------------------------------------------
# Deploy udiskie configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


udiskie::install () {
    echo "└> Installing udiskie configuration."

    ensure_directory "$XDG_CONFIG_HOME/systemd/user"
    force_link "$base_dir/config/systemd/user/udiskie.service" "$XDG_CONFIG_HOME/systemd/user/udiskie.service"
}

udiskie::uninstall () {
    echo "└> Uninstalling udiskie configuration."

    rm "$XDG_CONFIG_HOME/systemd/user/udiskie.service"
}

udiskie::enable () {
    echo "└> Enabling udiskie user service."

    systemctl --user enable udiskie
}

udiskie::disable () {
    echo "└> Disabling udiskie user service."

    systemctl --user disable udiskie
}
