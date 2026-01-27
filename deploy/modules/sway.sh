#-------------------------------------------------------------------------------
# Deploy sway configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
host=$(uname -n)

source "$base_dir/config/lib-shell-utils/fs.sh"


sway::install () {
    echo "└> Installing sway configuration."

    ensure_directory "$XDG_CONFIG_HOME/sway"
    force_link "$base_dir/config/sway/config" "$XDG_CONFIG_HOME/sway/config"
    force_link "$base_dir/config/sway/environment.sh" "$XDG_CONFIG_HOME/sway/environment.sh"
    force_link "$base_dir/config/sway/keymaps.conf" "$XDG_CONFIG_HOME/sway/keymaps.conf"
    force_link "$base_dir/config/sway/refresh.sh" "$XDG_CONFIG_HOME/sway/refresh.sh"
    force_link "$base_dir/config/sway/sws.sh" "$XDG_CONFIG_HOME/sway/sws.sh"

    if [[ $host == "casino" ]]; then
        force_link "$base_dir/config/sway/outputs.conf~home-dual" "$XDG_CONFIG_HOME/sway/outputs.conf"
        force_link "$base_dir/config/sway/workspace.conf~home-dual" "$XDG_CONFIG_HOME/sway/workspace.conf"

    elif [[ $host == "cyxwel" ]]; then
        force_link "$base_dir/config/sway/outputs.conf~home-dual" "$XDG_CONFIG_HOME/sway/outputs.conf"
        force_link "$base_dir/config/sway/workspace.conf~home-dual" "$XDG_CONFIG_HOME/sway/workspace.conf"

    elif [[ $host == "supertubes" ]]; then
        force_link "$base_dir/config/sway/outputs.conf~home-dual" "$XDG_CONFIG_HOME/sway/outputs.conf"
        force_link "$base_dir/config/sway/workspace.conf~home-dual" "$XDG_CONFIG_HOME/sway/workspace.conf"

    elif [[ $host == "vortex" ]]; then
        force_link "$base_dir/config/sway/outputs.conf~intelic" "$XDG_CONFIG_HOME/sway/outputs.conf"
        force_link "$base_dir/config/sway/workspace.conf~intelic" "$XDG_CONFIG_HOME/sway/workspace.conf"

    else
        echo "└> Warning: No outputs.conf configuration for host '$host'."
    fi

    esh -o "$XDG_CONFIG_HOME/sway/theme.conf" "$base_dir/config/sway/theme.conf~esh"

    echo "└> Installing sway shortcuts."

    ensure_directory "$XDG_BIN_HOME"
    force_link "$base_dir/config/sway/sway-run.sh" "$XDG_BIN_HOME/sway-run"

    if [[ $DEPLOY_WM == "sway" ]]; then
        echo "└> Autorun sway on login."

        force_link "$base_dir/config/sway/init~sway" "$XDG_BIN_HOME/init"
    fi
}

sway::uninstall () {
    echo "└> Uninstalling sway configuration."

    rm -r "$XDG_CONFIG_HOME/sway"

    echo "└> Uninstalling sway shortcuts."

    rm "$XDG_BIN_HOME/sway-run"

    if same_file "$XDG_BIN_HOME/init" "$base_dir/config/sway/init~sway"; then
        rm "$XDG_BIN_HOME/init"
    fi
}
