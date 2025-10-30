#-------------------------------------------------------------------------------
# Deploy waybar configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


waybar::install () {
    echo "└> Installing waybar configuration."

    ensure_directory "$XDG_CONFIG_HOME/waybar"

    if [[ $DEPLOY_WM == "hyprland" ]]; then
        force_link "$base_dir/config/waybar/hyprland-config" "$XDG_CONFIG_HOME/waybar/config"
        esh "$base_dir/config/waybar/hyprland-style.css~esh" > "$XDG_CONFIG_HOME/waybar/style.css"

    elif [[ $DEPLOY_WM == "niri" ]]; then
        force_link "$base_dir/config/waybar/niri-config" "$XDG_CONFIG_HOME/waybar/config"
        esh "$base_dir/config/waybar/niri-style.css~esh" > "$XDG_CONFIG_HOME/waybar/style.css"

    elif [[ $DEPLOY_WM == "river" ]]; then
        force_link "$base_dir/config/waybar/river-config" "$XDG_CONFIG_HOME/waybar/config"
        esh "$base_dir/config/waybar/river-style.css~esh" > "$XDG_CONFIG_HOME/waybar/style.css"

    elif [[ $DEPLOY_WM == "sway" ]]; then
        force_link "$base_dir/config/waybar/sway-config" "$XDG_CONFIG_HOME/waybar/config"
        esh "$base_dir/config/waybar/sway-style.css~esh" > "$XDG_CONFIG_HOME/waybar/style.css"

    elif [[ -z $DEPLOY_WM ]]; then
        echo "[$(basename "$0")] ERROR: \$DEPLOY_WM not set."
        exit 2

    else
        echo "[$(basename "$0")] ERROR: \`$DEPLOY_WM\` is not accounted for."
        exit 1
    fi

    force_link "$base_dir/config/waybar/restart-waybar.sh" "$XDG_SCRIPTS_HOME/restart-waybar.sh"
    force_link "$base_dir/config/waybar/toggle-waybar.sh" "$XDG_SCRIPTS_HOME/toggle-waybar.sh"

    force_link "$base_dir/config/waybar/tailscale.sh" "$XDG_CONFIG_HOME/waybar/tailscale.sh"
}

waybar::uninstall () {
    echo "└> Uninstalling waybar configuration."

    rm "$XDG_CONFIG_HOME/waybar"
    rm "$XDG_SCRIPTS_HOME/restart-waybar.sh"
    rm "$XDG_SCRIPTS_HOME/toggle-waybar.sh"
}
