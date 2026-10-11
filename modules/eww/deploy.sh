#-------------------------------------------------------------------------------
# Deploy eww configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


eww::install () {
    echo "└> Installing eww configuration."

    local src="$base_dir/modules/eww/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/eww"
    fs::force_link "$src/eww.yuck" "$XDG_CONFIG_HOME/eww/eww.yuck"
    fs::force_link "$src/yuck" "$XDG_CONFIG_HOME/eww/yuck"
    fs::force_link "$src/scripts" "$XDG_CONFIG_HOME/eww/scripts"
    template::render_mako "$src/eww.mako.scss" "$XDG_CONFIG_HOME/eww/eww.scss"

    fs::ensure_directory "$XDG_SCRIPTS_HOME"
    fs::force_link "$src/eww-bar.sh" "$XDG_SCRIPTS_HOME/eww-bar.sh"

    local icon
    fs::ensure_directory "$XDG_DATA_HOME/icons/hicolor/scalable/apps"
    for icon in "$src"/icons/*.svg; do
        fs::force_link "$icon" "$XDG_DATA_HOME/icons/hicolor/scalable/apps/$(basename "$icon")"
    done
    gtk-update-icon-cache -q -f -t "$XDG_DATA_HOME/icons/hicolor"

    # Eww does not watch files behind the symlinked config.
    if eww ping &> /dev/null; then
        echo "└> Reloading running eww daemon."
        eww reload
    fi
}

eww::uninstall () {
    echo "└> Uninstalling eww configuration."

    rm -r "$XDG_CONFIG_HOME/eww"
    rm "$XDG_SCRIPTS_HOME/eww-bar.sh"
    local icon
    for icon in "$base_dir"/modules/eww/src/icons/*.svg; do
        rm "$XDG_DATA_HOME/icons/hicolor/scalable/apps/$(basename "$icon")"
    done
    gtk-update-icon-cache -q -f -t "$XDG_DATA_HOME/icons/hicolor"
}
