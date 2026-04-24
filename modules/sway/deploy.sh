#-------------------------------------------------------------------------------
# Deploy sway configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
host=$(uname -n)

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


sway::install () {
    echo "└> Installing sway configuration."

    local src="$base_dir/modules/sway/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/sway"
    fs::force_link "$src/config" "$XDG_CONFIG_HOME/sway/config"
    fs::force_link "$src/environment.sh" "$XDG_CONFIG_HOME/sway/environment.sh"
    fs::force_link "$src/keymaps.conf" "$XDG_CONFIG_HOME/sway/keymaps.conf"
    fs::force_link "$src/winrules.conf" "$XDG_CONFIG_HOME/sway/winrules.conf"
    fs::force_link "$src/reload.sh" "$XDG_CONFIG_HOME/sway/reload.sh"
    fs::force_link "$src/sws.sh" "$XDG_CONFIG_HOME/sway/sws.sh"
    fs::force_link "$src/outputs-workspace-mapper.sh" "$XDG_CONFIG_HOME/sway/outputs-workspace-mapper.sh"
    fs::force_link "$src/startup-workspace.sh" "$XDG_CONFIG_HOME/sway/startup-workspace.sh"

    if [[ $host == "casino" ]]; then
        fs::force_link "$src/outputs.casino.conf" "$XDG_CONFIG_HOME/sway/outputs.conf"
        fs::force_link "$src/output-order.casino" "$XDG_CONFIG_HOME/sway/output-order"

    elif [[ $host == "cyxwel" ]]; then
        fs::force_link "$src/outputs.cyxwel.conf" "$XDG_CONFIG_HOME/sway/outputs.conf"
        fs::force_link "$src/output-order.cyxwel" "$XDG_CONFIG_HOME/sway/output-order"

    else
        echo "└> Warning: No outputs configuration for host '$host'."
    fi

    template::render_mako "$src/workspaces.mako.conf" "$XDG_CONFIG_HOME/sway/workspaces.conf"
    template::render_mako "$src/theme.mako.conf" "$XDG_CONFIG_HOME/sway/theme.conf"

    echo "└> Installing sway shortcuts."

    fs::ensure_directory "$XDG_BIN_HOME"
    fs::force_link "$src/sway-run.sh" "$XDG_BIN_HOME/sway-run"

    fs::ensure_directory "$XDG_CONFIG_HOME/xdg-desktop-portal"
    fs::force_link "$src/sway-portals.conf" "$XDG_CONFIG_HOME/xdg-desktop-portal/sway-portals.conf"

    if [[ $DEPLOY_WM == "sway" ]]; then
        echo "└> Autorun sway on login."

        fs::force_link "$src/init.sway" "$XDG_BIN_HOME/init"
    fi
}

sway::uninstall () {
    echo "└> Uninstalling sway configuration."

    local src="$base_dir/modules/sway/src"

    rm -r "$XDG_CONFIG_HOME/sway"

    echo "└> Uninstalling sway shortcuts."

    rm "$XDG_BIN_HOME/sway-run"

    if fs::same_file "$XDG_BIN_HOME/init" "$src/init.sway"; then
        rm "$XDG_BIN_HOME/init"
    fi
}
