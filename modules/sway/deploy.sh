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

    ensure_directory "$XDG_CONFIG_HOME/sway"
    force_link "$src/config" "$XDG_CONFIG_HOME/sway/config"
    force_link "$src/environment.sh" "$XDG_CONFIG_HOME/sway/environment.sh"
    force_link "$src/keymaps.conf" "$XDG_CONFIG_HOME/sway/keymaps.conf"
    force_link "$src/refresh.sh" "$XDG_CONFIG_HOME/sway/refresh.sh"
    force_link "$src/sws.sh" "$XDG_CONFIG_HOME/sway/sws.sh"
    force_link "$src/outputs-workspace-mapper.sh" "$XDG_CONFIG_HOME/sway/outputs-workspace-mapper.sh"
    force_link "$src/startup-workspace.sh" "$XDG_CONFIG_HOME/sway/startup-workspace.sh"

    if [[ $host == "casino" ]]; then
        force_link "$src/outputs.conf~casino" "$XDG_CONFIG_HOME/sway/outputs.conf"
        force_link "$src/output-order~casino" "$XDG_CONFIG_HOME/sway/output-order"

    elif [[ $host == "cyxwel" ]]; then
        force_link "$src/outputs.conf~cyxwel" "$XDG_CONFIG_HOME/sway/outputs.conf"
        force_link "$src/output-order~cyxwel" "$XDG_CONFIG_HOME/sway/output-order"

    else
        echo "└> Warning: No outputs configuration for host '$host'."
    fi

    render_esh_template "$src/workspaces.conf~esh" "$XDG_CONFIG_HOME/sway/workspaces.conf"
    render_esh_template "$src/theme.conf~esh" "$XDG_CONFIG_HOME/sway/theme.conf"

    echo "└> Installing sway shortcuts."

    ensure_directory "$XDG_BIN_HOME"
    force_link "$src/sway-run.sh" "$XDG_BIN_HOME/sway-run"

    ensure_directory "$XDG_CONFIG_HOME/xdg-desktop-portal"
    force_link "$src/sway-portals.conf" "$XDG_CONFIG_HOME/xdg-desktop-portal/sway-portals.conf"

    if [[ $DEPLOY_WM == "sway" ]]; then
        echo "└> Autorun sway on login."

        force_link "$src/init~sway" "$XDG_BIN_HOME/init"
    fi
}

sway::uninstall () {
    echo "└> Uninstalling sway configuration."

    local src="$base_dir/modules/sway/src"

    rm -r "$XDG_CONFIG_HOME/sway"

    echo "└> Uninstalling sway shortcuts."

    rm "$XDG_BIN_HOME/sway-run"

    if same_file "$XDG_BIN_HOME/init" "$src/init~sway"; then
        rm "$XDG_BIN_HOME/init"
    fi
}
