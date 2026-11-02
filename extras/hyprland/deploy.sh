#-------------------------------------------------------------------------------
# Deploy hyprland configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


hyprland::install () {
    echo "└> Installing hyprland configuration."

    local src="$base_dir/modules/hyprland/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/hypr"

    # Configuration files.
    fs::force_link \
        "$src/hyprland.conf" \
        "$XDG_CONFIG_HOME/hypr/hyprland.conf"

    # Custom scripts.
    fs::force_link \
        "$src/close-window-under-cursor.sh" \
        "$XDG_CONFIG_HOME/hypr/close-window-under-cursor.sh"
    fs::force_link \
        "$src/move-window-hy3.sh" \
        "$XDG_CONFIG_HOME/hypr/move-window-hy3.sh"

    if [[ $DEPLOY_WM == "hyprland" ]]; then
        echo "└> Installing hyprland shortcuts."

        fs::ensure_directory "$XDG_BIN_HOME"
        fs::force_link \
            "$src/init.hyprland" \
            "$XDG_BIN_HOME/init"
    fi
}

hyprland::uninstall () {
    echo "└> Uninstalling hyprland configuration."

    local src="$base_dir/modules/hyprland/src"

    rm -r "$XDG_CONFIG_HOME/hypr"

    echo "└> Uninstalling hyprland shortcuts."

    if fs::same_file "$XDG_BIN_HOME/init" "$src/init.hyprland"; then
        rm "$XDG_BIN_HOME/init"
    fi
}
