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

    fs::ensure_directory "$XDG_CONFIG_HOME/waybar"

    # TODO: Use a symlink with window manager suffix to point to the correct waybar profile.
    if [[ $DEPLOY_WM == "hyprland" ]]; then
        fs::force_link "$src/hyprland-config" "$XDG_CONFIG_HOME/waybar/config"
        template::render_mako "$src/hyprland-style.mako.css" "$XDG_CONFIG_HOME/waybar/style.css"

    elif [[ $DEPLOY_WM == "niri" ]]; then
        fs::force_link "$src/niri-config" "$XDG_CONFIG_HOME/waybar/config"
        template::render_mako "$src/niri-style.mako.css" "$XDG_CONFIG_HOME/waybar/style.css"

    elif [[ $DEPLOY_WM == "river" ]]; then
        fs::force_link "$src/river-config" "$XDG_CONFIG_HOME/waybar/config"
        template::render_mako "$src/river-style.mako.css" "$XDG_CONFIG_HOME/waybar/style.css"

    elif [[ $DEPLOY_WM == "sway" ]]; then
        template::render_mako "$src/sway-config.mako" "$XDG_CONFIG_HOME/waybar/config"
        template::render_mako "$src/sway-style.mako.css" "$XDG_CONFIG_HOME/waybar/style.css"

    elif [[ -z $DEPLOY_WM ]]; then
        debug::error "\$DEPLOY_WM not set."
        exit 2

    else
        debug::error "\`$DEPLOY_WM\` is not accounted for."
        exit 1
    fi

    fs::force_link "$src/restart-waybar.sh" "$XDG_SCRIPTS_HOME/restart-waybar.sh"
    fs::force_link "$src/toggle-waybar.sh" "$XDG_SCRIPTS_HOME/toggle-waybar.sh"

    fs::force_link "$src/tailscale.sh" "$XDG_CONFIG_HOME/waybar/tailscale.sh"
    fs::force_link "$src/memory.sh" "$XDG_CONFIG_HOME/waybar/memory.sh"
}

waybar::uninstall () {
    echo "└> Uninstalling waybar configuration."

    rm "$XDG_CONFIG_HOME/waybar"
    rm "$XDG_SCRIPTS_HOME/restart-waybar.sh"
    rm "$XDG_SCRIPTS_HOME/toggle-waybar.sh"
}
