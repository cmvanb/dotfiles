#-------------------------------------------------------------------------------
# Deploy hyprland configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"
source "$base_dir/config/lib-shell-utils/template.sh"


hyprland::install () {
    echo "└> Installing hyprland configuration."

    ensure_directory "$XDG_CONFIG_HOME/hypr"

    # Configuration files.
    force_link \
        "$base_dir/config/hyprland/hyprland.conf" \
        "$XDG_CONFIG_HOME/hypr/hyprland.conf"
    render_esh_template \
        "$base_dir/config/hyprland/hyprlock.conf~esh" \
        "$XDG_CONFIG_HOME/hypr/hyprlock.conf"

    # Custom scripts.
    force_link \
        "$base_dir/config/hyprland/close-window-under-cursor.sh" \
        "$XDG_CONFIG_HOME/hypr/close-window-under-cursor.sh"
    force_link \
        "$base_dir/config/hyprland/move-window-hy3.sh" \
        "$XDG_CONFIG_HOME/hypr/move-window-hy3.sh"
    force_link \
        "$base_dir/config/hyprland/toggle-waybar.sh" \
        "$XDG_CONFIG_HOME/hypr/toggle-waybar.sh"

    if [[ $DEPLOY_WM == "hyprland" ]]; then
        echo "└> Installing hyprland shortcuts."

        ensure_directory "$XDG_BIN_HOME"
        force_link \
            "$base_dir/config/hyprland/init~hyprland" \
            "$XDG_BIN_HOME/init"
    fi
}

hyprland::uninstall () {
    echo "└> Uninstalling hyprland configuration."

    rm -r "$XDG_CONFIG_HOME/hypr"

    echo "└> Uninstalling hyprland shortcuts."

    if same_file "$XDG_BIN_HOME/init" "$base_dir/config/hyprland/init~hyprland"; then
        rm "$XDG_BIN_HOME/init"
    fi
}
