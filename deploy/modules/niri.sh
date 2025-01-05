#-------------------------------------------------------------------------------
# Deploy niri configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
bin_dir=${XDG_BIN_HOME:-$HOME/.local/bin}
host=$(uname -n)

source "$base_dir/local/opt/shell-utils/fs.sh"


niri::install () {
    echo "└> Installing niri configuration."

    if [[ $host == "supertubes" || $host == "cyxwel" ]]; then
        force_link "$base_dir/config/niri/workspace.sh~home-triple" "$config_dir/niri/workspace.sh"

    else
        echo "[$(basename "$0")] ERROR: \`$host\` is not accounted for."
        exit 1
    fi

    mkdir -p "$config_dir/niri"
    force_link "$base_dir/config/niri/config.kdl" "$config_dir/niri/config.kdl"
    force_link "$base_dir/config/niri/focus-window.sh" "$config_dir/niri/focus-window.sh"

    mkdir -p "$config_dir/systemd/user/niri.service.wants"
    force_link "/usr/lib/systemd/user/mako.service" "$config_dir/systemd/user/niri.service.wants/mako.service"
    force_link "/usr/lib/systemd/user/waybar.service" "$config_dir/systemd/user/niri.service.wants/waybar.service"

    mkdir -p "$config_dir/xdg-desktop-portal"
    force_link "$base_dir/config/niri/niri-portals.conf" "$config_dir/xdg-desktop-portal/niri-portals.conf"

    echo "└> Installing niri shortcuts."

    mkdir -p "$bin_dir"
    force_link "$base_dir/local/bin/init~niri" "$bin_dir/init"
}

niri::uninstall () {
    echo "└> Uninstalling niri configuration."

    rm -r "$config_dir/niri"
    rm -r "$config_dir/systemd/user/niri.service.wants"

    rm "$config_dir/xdg-desktop-portal/niri-portals.conf"

    echo "└> Uninstalling niri shortcuts."

    rm "$bin_dir/init"
}
