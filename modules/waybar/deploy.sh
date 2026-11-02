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

    # Each window manager has its own variant: config.<wm>[.mako], style.<wm>.mako.css
    if [[ -z $DEPLOY_WM ]]; then
        debug::error "\$DEPLOY_WM not set."
        exit 2
    fi

    local config="$src/config.$DEPLOY_WM"
    local style="$src/style.$DEPLOY_WM.mako.css"

    if [[ -f "$config.mako" ]]; then
        template::render_mako "$config.mako" "$XDG_CONFIG_HOME/waybar/config"
    elif [[ -f "$config" ]]; then
        fs::force_link "$config" "$XDG_CONFIG_HOME/waybar/config"
    else
        debug::error "No waybar config for \`$DEPLOY_WM\`."
        exit 1
    fi

    template::render_mako "$style" "$XDG_CONFIG_HOME/waybar/style.css"

    fs::force_link "$src/restart-waybar.sh" "$XDG_SCRIPTS_HOME/restart-waybar.sh"
    fs::force_link "$src/toggle-waybar.sh" "$XDG_SCRIPTS_HOME/toggle-waybar.sh"

    fs::force_link "$src/tailscale.sh" "$XDG_CONFIG_HOME/waybar/tailscale.sh"
    fs::force_link "$src/memory.sh" "$XDG_CONFIG_HOME/waybar/memory.sh"
    fs::force_link "$src/cpu.sh" "$XDG_CONFIG_HOME/waybar/cpu.sh"
    fs::force_link "$src/claude.sh" "$XDG_CONFIG_HOME/waybar/claude.sh"
}

waybar::uninstall () {
    echo "└> Uninstalling waybar configuration."

    fs::remove "$XDG_CONFIG_HOME/waybar"
    fs::remove "$XDG_SCRIPTS_HOME/restart-waybar.sh"
    fs::remove "$XDG_SCRIPTS_HOME/toggle-waybar.sh"
}
