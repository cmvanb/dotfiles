#-------------------------------------------------------------------------------
# Deploy river configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
host=$(uname -n)

source "$base_dir/lib/fs.sh"


river::install () {
    echo "└> Installing river configuration."

    local src="$base_dir/modules/river/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/river"

    if [[ $host == "supertubes" || $host == "cyxwel" ]]; then
        fs::force_link "$src/workspace.home-triple.sh" "$XDG_CONFIG_HOME/river/workspace.sh"

    fi

    fs::force_link "$src/environment.sh" "$XDG_CONFIG_HOME/river/environment.sh"
    fs::force_link "$src/init" "$XDG_CONFIG_HOME/river/init"
    fs::force_link "$src/keymaps.sh" "$XDG_CONFIG_HOME/river/keymaps.sh"
    fs::force_link "$src/refresh.sh" "$XDG_CONFIG_HOME/river/refresh.sh"
    fs::force_link "$src/send-and-focus-output.sh" "$XDG_CONFIG_HOME/river/send-and-focus-output.sh"
    fs::force_link "$src/send-to-output.sh" "$XDG_CONFIG_HOME/river/send-to-output.sh"
    fs::force_link "$src/send-view-to-tag.sh" "$XDG_CONFIG_HOME/river/send-view-to-tag.sh"
    fs::force_link "$src/theme.sh" "$XDG_CONFIG_HOME/river/theme.sh"
    fs::force_link "$src/utils.sh" "$XDG_CONFIG_HOME/river/utils.sh"

    fs::ensure_directory "$XDG_CONFIG_HOME/xdg-desktop-portal"
    fs::force_link "$src/river-portals.conf" "$XDG_CONFIG_HOME/xdg-desktop-portal/river-portals.conf"

    if [[ $DEPLOY_WM == "river" ]]; then
        echo "└> Installing river shortcuts."

        fs::ensure_directory "$XDG_BIN_HOME"
        fs::force_link "$src/river-log.sh" "$XDG_BIN_HOME/river-log"
        fs::force_link "$src/refresh.sh" "$XDG_BIN_HOME/river-refresh"
        fs::force_link "$src/river-run.sh" "$XDG_BIN_HOME/river-run"
        fs::force_link "$src/init.river" "$XDG_BIN_HOME/init"
    fi
}

river::uninstall () {
    echo "└> Uninstalling river configuration."

    local src="$base_dir/modules/river/src"

    rm -r "$XDG_CONFIG_HOME/river"

    rm "$XDG_CONFIG_HOME/xdg-desktop-portal/river-portals.conf"

    echo "└> Uninstalling river shortcuts."

    rm "$XDG_BIN_HOME/river-log"
    rm "$XDG_BIN_HOME/river-run"
    if fs::same_file "$XDG_BIN_HOME/init" "$src/init.river"; then
        rm "$XDG_BIN_HOME/init"
    fi
}
