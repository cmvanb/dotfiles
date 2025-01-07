#-------------------------------------------------------------------------------
# Deploy niri configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
host=$(uname -n)

source "$base_dir/config/lib-shell-utils/fs.sh"


niri::install () {
    echo "└> Installing niri configuration."

    if [[ $host == "supertubes" || $host == "cyxwel" ]]; then
        force_link "$base_dir/config/niri/workspace.sh~home-triple" "$XDG_CONFIG_HOME/niri/workspace.sh"

    else
        echo "[$(basename "$0")] ERROR: \`$host\` is not accounted for."
        exit 1
    fi

    mkdir -p "$XDG_CONFIG_HOME/niri"
    force_link "$base_dir/config/niri/config.kdl" "$XDG_CONFIG_HOME/niri/config.kdl"
    force_link "$base_dir/config/niri/focus-window.sh" "$XDG_CONFIG_HOME/niri/focus-window.sh"

    mkdir -p "$XDG_CONFIG_HOME/systemd/user/niri.service.wants"
    force_link "/usr/lib/systemd/user/mako.service" "$XDG_CONFIG_HOME/systemd/user/niri.service.wants/mako.service"
    force_link "/usr/lib/systemd/user/waybar.service" "$XDG_CONFIG_HOME/systemd/user/niri.service.wants/waybar.service"

    mkdir -p "$XDG_CONFIG_HOME/xdg-desktop-portal"
    force_link "$base_dir/config/niri/niri-portals.conf" "$XDG_CONFIG_HOME/xdg-desktop-portal/niri-portals.conf"

    echo "└> Installing niri shortcuts."

    mkdir -p "$XDG_BIN_HOME"
    force_link "$base_dir/config/niri/init~niri" "$XDG_BIN_HOME/init"
}

niri::uninstall () {
    echo "└> Uninstalling niri configuration."

    rm -r "$XDG_CONFIG_HOME/niri"
    rm -r "$XDG_CONFIG_HOME/systemd/user/niri.service.wants"

    rm "$XDG_CONFIG_HOME/xdg-desktop-portal/niri-portals.conf"

    echo "└> Uninstalling niri shortcuts."

    rm "$XDG_BIN_HOME/init"
}
