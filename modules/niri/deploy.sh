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

    fs::ensure_directory "$XDG_CONFIG_HOME/niri"
    fs::force_link "$src/config.kdl" "$XDG_CONFIG_HOME/niri/config.kdl"
    fs::force_link "$src/keymaps.kdl" "$XDG_CONFIG_HOME/niri/keymaps.kdl"
    fs::force_link "$src/winrules.kdl" "$XDG_CONFIG_HOME/niri/winrules.kdl"
    fs::force_link "$src/scripts" "$XDG_CONFIG_HOME/niri/scripts"

    if [[ $host == "casino" ]]; then
        fs::force_link "$src/outputs/outputs.casino.kdl" "$XDG_CONFIG_HOME/niri/outputs.kdl"

    elif [[ $host == "cyxwel" ]]; then
        fs::force_link "$src/outputs/outputs.cyxwel.kdl" "$XDG_CONFIG_HOME/niri/outputs.kdl"

    else
        echo "└> Warning: No outputs configuration for host '$host'."
    fi

    if [[ -f "$src/layout/layout.$host.kdl" ]]; then
        fs::force_link "$src/layout/layout.$host.kdl" "$XDG_CONFIG_HOME/niri/layout.kdl"
    fi

    template::render_mako "$src/outputs/workspaces.mako.kdl" "$XDG_CONFIG_HOME/niri/workspaces.kdl"
    template::render_mako "$src/theme.mako.kdl" "$XDG_CONFIG_HOME/niri/theme.kdl"

    fs::ensure_directory "$XDG_BIN_HOME"
    fs::force_link "$src/scripts/niri-ws.sh" "$XDG_BIN_HOME/niri-ws"

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

    fs::remove "$XDG_CONFIG_HOME/niri"
    fs::remove "$XDG_CONFIG_HOME/xdg-desktop-portal/niri-portals.conf"
    fs::remove "$XDG_BIN_HOME/niri-ws"

    if fs::same_file "$XDG_BIN_HOME/init" "$src/init.niri"; then
        fs::remove "$XDG_BIN_HOME/init"
    fi
}
