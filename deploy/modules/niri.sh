#-------------------------------------------------------------------------------
# Deploy niri configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
host=$(uname -n)

source "$base_dir/config/lib-shell-utils/fs.sh"


niri::install () {
    echo "└> Installing niri configuration."

    ensure_directory "$XDG_CONFIG_HOME/niri"

    if [[ $host == "supertubes" || $host == "cyxwel" ]]; then
        force_link "$base_dir/config/niri/workspace.sh~home-triple" "$XDG_CONFIG_HOME/niri/workspace.sh"

    fi

    force_link "$base_dir/config/niri/config.kdl" "$XDG_CONFIG_HOME/niri/config.kdl"
    force_link "$base_dir/config/niri/focus-window.sh" "$XDG_CONFIG_HOME/niri/focus-window.sh"

    ensure_directory "$XDG_CONFIG_HOME/systemd/user/niri.service.wants"
    force_link "/usr/lib/systemd/user/mako.service" "$XDG_CONFIG_HOME/systemd/user/niri.service.wants/mako.service"
    force_link "/usr/lib/systemd/user/waybar.service" "$XDG_CONFIG_HOME/systemd/user/niri.service.wants/waybar.service"

    ensure_directory "$XDG_CONFIG_HOME/xdg-desktop-portal"
    force_link "$base_dir/config/niri/niri-portals.conf" "$XDG_CONFIG_HOME/xdg-desktop-portal/niri-portals.conf"

    if [[ $DEPLOY_WM == "niri" ]]; then
        echo "└> Installing niri shortcuts."

        ensure_directory "$XDG_BIN_HOME"
        force_link "$base_dir/config/niri/init~niri" "$XDG_BIN_HOME/init"
    fi
}

niri::uninstall () {
    echo "└> Uninstalling niri configuration."

    rm -r "$XDG_CONFIG_HOME/niri"
    rm -r "$XDG_CONFIG_HOME/systemd/user/niri.service.wants"

    rm "$XDG_CONFIG_HOME/xdg-desktop-portal/niri-portals.conf"

    echo "└> Uninstalling niri shortcuts."

    if same_file "$XDG_BIN_HOME/init" "$base_dir/config/niri/init~niri"; then
        rm "$XDG_BIN_HOME/init"
    fi
}
