#-------------------------------------------------------------------------------
# Deploy sway configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
host=$(uname -n)

source "$base_dir/modules/lib-shell-utils/src/fs.sh"


sway::install () {
    echo "└> Installing sway configuration."

    local src="$base_dir/modules/sway/src"

    ensure_directory "$XDG_CONFIG_HOME/sway"
    force_link "$src/config" "$XDG_CONFIG_HOME/sway/config"
    force_link "$src/environment.sh" "$XDG_CONFIG_HOME/sway/environment.sh"
    force_link "$src/keymaps.conf" "$XDG_CONFIG_HOME/sway/keymaps.conf"
    force_link "$src/refresh.sh" "$XDG_CONFIG_HOME/sway/refresh.sh"
    force_link "$src/sws.sh" "$XDG_CONFIG_HOME/sway/sws.sh"

    if [[ $host == "casino" ]]; then
        force_link "$src/outputs.conf~home-laptop" "$XDG_CONFIG_HOME/sway/outputs.conf"
        force_link "$src/workspace.conf~home-laptop" "$XDG_CONFIG_HOME/sway/workspace.conf"

    elif [[ $host == "cyxwel" ]]; then
        force_link "$src/outputs.conf~home-dual" "$XDG_CONFIG_HOME/sway/outputs.conf"
        force_link "$src/workspace.conf~home-dual" "$XDG_CONFIG_HOME/sway/workspace.conf"

    elif [[ $host == "supertubes" ]]; then
        force_link "$src/outputs.conf~home-dual" "$XDG_CONFIG_HOME/sway/outputs.conf"
        force_link "$src/workspace.conf~home-dual" "$XDG_CONFIG_HOME/sway/workspace.conf"

    else
        echo "└> Warning: No outputs.conf configuration for host '$host'."
    fi

    esh -o "$XDG_CONFIG_HOME/sway/theme.conf" "$src/theme.conf~esh"

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
