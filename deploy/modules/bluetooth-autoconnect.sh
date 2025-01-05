#-------------------------------------------------------------------------------
# Deploy bluetooth-autoconnect configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


bluetooth-autoconnect::install () {
    echo "└> Installing bluetooth-autoconnect configuration."

    mkdir -p "$config_dir/systemd/user"
    force_link "$base_dir/config/systemd/user/bluetooth-autoconnect.service" "$config_dir/systemd/user/bluetooth-autoconnect.service"
}

bluetooth-autoconnect::uninstall () {
    echo "└> Uninstalling bluetooth-autoconnect configuration."

    rm "$config_dir/systemd/user/bluetooth-autoconnect.service"
}
