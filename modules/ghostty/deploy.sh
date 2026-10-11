#-------------------------------------------------------------------------------
# Deploy ghostty configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


ghostty::install () {
    echo "└> Installing ghostty configuration."

    local src="$base_dir/modules/ghostty/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/ghostty"
    template::render_mako "$src/config.mako" "$XDG_CONFIG_HOME/ghostty/config"

    fs::ensure_directory "$XDG_CONFIG_HOME/ghostty/themes"
    template::render_mako "$src/themes/custom-theme.mako" "$XDG_CONFIG_HOME/ghostty/themes/custom-theme"

    # Packaged rasters win icon lookups by name, so the user desktop entry
    # shadows the system one and points at a distinctly named icon.
    fs::ensure_directory "$XDG_DATA_HOME/icons/hicolor/scalable/apps"
    fs::force_link "$src/icons/ghostty-ghost.svg" "$XDG_DATA_HOME/icons/hicolor/scalable/apps/ghostty-ghost.svg"
    gtk-update-icon-cache -q -f -t "$XDG_DATA_HOME/icons/hicolor"
    fs::ensure_directory "$XDG_DATA_HOME/applications"
    sed 's/^Icon=.*/Icon=ghostty-ghost/' /usr/share/applications/com.mitchellh.ghostty.desktop \
        > "$XDG_DATA_HOME/applications/com.mitchellh.ghostty.desktop"
}

ghostty::uninstall () {
    echo "└> Uninstalling ghostty configuration."

    rm -r "$XDG_CONFIG_HOME/ghostty"
    rm "$XDG_DATA_HOME/icons/hicolor/scalable/apps/ghostty-ghost.svg"
    gtk-update-icon-cache -q -f -t "$XDG_DATA_HOME/icons/hicolor"
    rm "$XDG_DATA_HOME/applications/com.mitchellh.ghostty.desktop"
}
