#-------------------------------------------------------------------------------
# Deploy river configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
host=$(uname -n)

source "$base_dir/config/lib-shell-utils/fs.sh"


river::install () {
    echo "└> Installing river configuration."

    ensure_directory "$XDG_CONFIG_HOME/river"

    if [[ $host == "supertubes" || $host == "cyxwel" ]]; then
        force_link "$base_dir/config/river/workspace.sh~home-triple" "$XDG_CONFIG_HOME/river/workspace.sh"

    fi

    force_link "$base_dir/config/river/environment.sh" "$XDG_CONFIG_HOME/river/environment.sh"
    force_link "$base_dir/config/river/init" "$XDG_CONFIG_HOME/river/init"
    force_link "$base_dir/config/river/keymaps.sh" "$XDG_CONFIG_HOME/river/keymaps.sh"
    force_link "$base_dir/config/river/refresh.sh" "$XDG_CONFIG_HOME/river/refresh.sh"
    force_link "$base_dir/config/river/send-and-focus-output.sh" "$XDG_CONFIG_HOME/river/send-and-focus-output.sh"
    force_link "$base_dir/config/river/send-to-output.sh" "$XDG_CONFIG_HOME/river/send-to-output.sh"
    force_link "$base_dir/config/river/send-view-to-tag.sh" "$XDG_CONFIG_HOME/river/send-view-to-tag.sh"
    force_link "$base_dir/config/river/theme.sh" "$XDG_CONFIG_HOME/river/theme.sh"
    force_link "$base_dir/config/river/utils.sh" "$XDG_CONFIG_HOME/river/utils.sh"

    ensure_directory "$XDG_CONFIG_HOME/xdg-desktop-portal"
    force_link "$base_dir/config/river/river-portals.conf" "$XDG_CONFIG_HOME/xdg-desktop-portal/river-portals.conf"

    if [[ $DEPLOY_WM == "river" ]]; then
        echo "└> Installing river shortcuts."

        ensure_directory "$XDG_BIN_HOME"
        force_link "$base_dir/config/river/river-log.sh" "$XDG_BIN_HOME/river-log"
        force_link "$base_dir/config/river/refresh.sh" "$XDG_BIN_HOME/river-refresh"
        force_link "$base_dir/config/river/river-run.sh" "$XDG_BIN_HOME/river-run"
        force_link "$base_dir/config/river/init~river" "$XDG_BIN_HOME/init"
    fi
}

river::uninstall () {
    echo "└> Uninstalling river configuration."

    rm -r "$XDG_CONFIG_HOME/river"

    rm "$XDG_CONFIG_HOME/xdg-desktop-portal/river-portals.conf"

    echo "└> Uninstalling river shortcuts."

    rm "$XDG_BIN_HOME/river-log"
    rm "$XDG_BIN_HOME/river-run"
    if same_file "$XDG_BIN_HOME/init" "$base_dir/config/river/init~river"; then
        rm "$XDG_BIN_HOME/init"
    fi
}
