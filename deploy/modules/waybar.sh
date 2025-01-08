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

    else
        echo "[$(basename "$0")] ERROR: \`$DEPLOY_WM\` is not accounted for."
        exit 1
    fi
}

waybar::uninstall () {
    echo "└> Uninstalling waybar configuration."

    rm "$XDG_CONFIG_HOME/waybar"
}
