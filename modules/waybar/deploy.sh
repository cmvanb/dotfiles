#-------------------------------------------------------------------------------
# Deploy waybar configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


waybar::install () {
    echo "└> Installing waybar configuration."

    local src="$base_dir/modules/waybar/src"

    ensure_directory "$XDG_CONFIG_HOME/waybar"

    # TODO: Use a symlink with window manager suffix to point to the correct waybar profile.
    if [[ $DEPLOY_WM == "hyprland" ]]; then
        force_link "$src/hyprland-config" "$XDG_CONFIG_HOME/waybar/config"
        render_esh_template "$src/hyprland-style.css~esh" "$XDG_CONFIG_HOME/waybar/style.css"

    elif [[ $DEPLOY_WM == "niri" ]]; then
        force_link "$src/niri-config" "$XDG_CONFIG_HOME/waybar/config"
        render_esh_template "$src/niri-style.css~esh" "$XDG_CONFIG_HOME/waybar/style.css"

    elif [[ $DEPLOY_WM == "river" ]]; then
        force_link "$src/river-config" "$XDG_CONFIG_HOME/waybar/config"
        render_esh_template "$src/river-style.css~esh" "$XDG_CONFIG_HOME/waybar/style.css"

    elif [[ $DEPLOY_WM == "sway" ]]; then
        force_link "$src/sway-config" "$XDG_CONFIG_HOME/waybar/config"
        render_esh_template "$src/sway-style.css~esh" "$XDG_CONFIG_HOME/waybar/style.css"

    elif [[ -z $DEPLOY_WM ]]; then
        echo "[$(basename "$0")] ERROR: \$DEPLOY_WM not set."
        exit 2

    else
        echo "[$(basename "$0")] ERROR: \`$DEPLOY_WM\` is not accounted for."
        exit 1
    fi

    force_link "$src/restart-waybar.sh" "$XDG_SCRIPTS_HOME/restart-waybar.sh"
    force_link "$src/toggle-waybar.sh" "$XDG_SCRIPTS_HOME/toggle-waybar.sh"

    force_link "$src/tailscale.sh" "$XDG_CONFIG_HOME/waybar/tailscale.sh"
}

waybar::uninstall () {
    echo "└> Uninstalling waybar configuration."

    rm "$XDG_CONFIG_HOME/waybar"
    rm "$XDG_SCRIPTS_HOME/restart-waybar.sh"
    rm "$XDG_SCRIPTS_HOME/toggle-waybar.sh"
}
