#-------------------------------------------------------------------------------
# Deploy udiskie configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


udiskie::install () {
    echo "└> Installing udiskie configuration."

    mkdir -p "$config_dir/systemd/user"
    force_link "$base_dir/config/systemd/user/udiskie.service" "$config_dir/systemd/user/udiskie.service"
}

udiskie::uninstall () {
    echo "└> Uninstalling udiskie configuration."

    rm "$config_dir/systemd/user/udiskie.service"
}
