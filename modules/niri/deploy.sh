#-------------------------------------------------------------------------------
# Deploy niri configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
host=$(uname -n)

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


niri::install () {
    echo "└> Installing niri configuration."

    local src="$base_dir/modules/niri/src"
    local sway_src="$base_dir/modules/sway/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/niri"
    fs::force_link "$src/config.kdl" "$XDG_CONFIG_HOME/niri/config.kdl"
    fs::force_link "$src/keymaps.kdl" "$XDG_CONFIG_HOME/niri/keymaps.kdl"
    fs::force_link "$src/winrules.kdl" "$XDG_CONFIG_HOME/niri/winrules.kdl"
    fs::force_link "$src/scripts" "$XDG_CONFIG_HOME/niri/scripts"
    fs::force_link "$sway_src/wsesh" "$XDG_CONFIG_HOME/niri/wsesh"

    if [[ $host == "casino" ]]; then
        fs::force_link "$src/outputs/outputs.casino.kdl" "$XDG_CONFIG_HOME/niri/outputs.kdl"
        fs::force_link "$sway_src/outputs/output-order.casino" "$XDG_CONFIG_HOME/niri/output-order"

    elif [[ $host == "cyxwel" ]]; then
        fs::force_link "$src/outputs/outputs.cyxwel.kdl" "$XDG_CONFIG_HOME/niri/outputs.kdl"
        fs::force_link "$sway_src/outputs/output-order.cyxwel" "$XDG_CONFIG_HOME/niri/output-order"

    else
        echo "└> Warning: No outputs configuration for host '$host'."
    fi

    template::render_mako "$src/outputs/workspaces.mako" "$XDG_CONFIG_HOME/niri/workspaces"
    template::render_mako "$src/theme.mako.kdl" "$XDG_CONFIG_HOME/niri/theme.kdl"

    # The old module made niri.service want waybar and mako, which fight eww
    # and swaync.
    rm -rf "$XDG_CONFIG_HOME/systemd/user/niri.service.wants"

    fs::ensure_directory "$XDG_CONFIG_HOME/xdg-desktop-portal"
    fs::force_link "$src/niri-portals.conf" "$XDG_CONFIG_HOME/xdg-desktop-portal/niri-portals.conf"

    if [[ $DEPLOY_WM == "niri" ]]; then
        echo "└> Autorun niri on login."

        fs::ensure_directory "$XDG_BIN_HOME"
        fs::force_link "$src/init.niri" "$XDG_BIN_HOME/init"
    fi
}

niri::uninstall () {
    echo "└> Uninstalling niri configuration."

    local src="$base_dir/modules/niri/src"

    rm -r "$XDG_CONFIG_HOME/niri"
    rm "$XDG_CONFIG_HOME/xdg-desktop-portal/niri-portals.conf"

    if fs::same_file "$XDG_BIN_HOME/init" "$src/init.niri"; then
        rm "$XDG_BIN_HOME/init"
    fi
}
