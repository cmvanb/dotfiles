#-------------------------------------------------------------------------------
# Deploy niri configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
host=$(uname -n)

source "$base_dir/lib/fs.sh"


niri::install () {
    echo "└> Installing niri configuration."

    fs::ensure_directory "$XDG_CONFIG_HOME/niri"

    if [[ $host == "supertubes" || $host == "cyxwel" ]]; then
        fs::force_link "$base_dir/modules/niri/src/workspace.home-triple.sh" "$XDG_CONFIG_HOME/niri/workspace.sh"

    fi

    fs::force_link "$base_dir/modules/niri/src/config.kdl" "$XDG_CONFIG_HOME/niri/config.kdl"
    fs::force_link "$base_dir/modules/niri/src/focus-window.sh" "$XDG_CONFIG_HOME/niri/focus-window.sh"

    fs::ensure_directory "$XDG_CONFIG_HOME/systemd/user/niri.service.wants"
    fs::force_link "/usr/lib/systemd/user/mako.service" "$XDG_CONFIG_HOME/systemd/user/niri.service.wants/mako.service"
    fs::force_link "/usr/lib/systemd/user/waybar.service" "$XDG_CONFIG_HOME/systemd/user/niri.service.wants/waybar.service"

    fs::ensure_directory "$XDG_CONFIG_HOME/xdg-desktop-portal"
    fs::force_link "$base_dir/modules/niri/src/niri-portals.conf" "$XDG_CONFIG_HOME/xdg-desktop-portal/niri-portals.conf"

    if [[ $DEPLOY_WM == "niri" ]]; then
        echo "└> Installing niri shortcuts."

        fs::ensure_directory "$XDG_BIN_HOME"
        fs::force_link "$base_dir/modules/niri/src/init.niri" "$XDG_BIN_HOME/init"
    fi
}

niri::uninstall () {
    echo "└> Uninstalling niri configuration."

    rm -r "$XDG_CONFIG_HOME/niri"
    rm -r "$XDG_CONFIG_HOME/systemd/user/niri.service.wants"

    rm "$XDG_CONFIG_HOME/xdg-desktop-portal/niri-portals.conf"

    echo "└> Uninstalling niri shortcuts."

    if fs::same_file "$XDG_BIN_HOME/init" "$base_dir/modules/niri/src/init.niri"; then
        rm "$XDG_BIN_HOME/init"
    fi
}
