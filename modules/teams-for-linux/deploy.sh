#-------------------------------------------------------------------------------
# Deploy teams-for-linux configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


teams-for-linux::install () {
    echo "└> Installing teams-for-linux configuration."

    local src="$base_dir/modules/teams-for-linux/src"

    # Packaged rasters win icon lookups by name, so the user desktop entry
    # shadows the system one and points at a distinctly named icon.
    fs::ensure_directory "$XDG_DATA_HOME/icons/hicolor/scalable/apps"
    template::render_mako "$src/icons/teams-badge.mako.svg" "$XDG_DATA_HOME/icons/hicolor/scalable/apps/teams-badge.svg" carbon-dark
    gtk-update-icon-cache -q -f -t "$XDG_DATA_HOME/icons/hicolor"

    fs::ensure_directory "$XDG_DATA_HOME/applications"
    sed 's/^Icon=.*/Icon=teams-badge/' /usr/share/applications/teams-for-linux.desktop \
        > "$XDG_DATA_HOME/applications/teams-for-linux.desktop"
}

teams-for-linux::uninstall () {
    echo "└> Uninstalling teams-for-linux configuration."

    rm "$XDG_DATA_HOME/applications/teams-for-linux.desktop"
    rm "$XDG_DATA_HOME/icons/hicolor/scalable/apps/teams-badge.svg"
    gtk-update-icon-cache -q -f -t "$XDG_DATA_HOME/icons/hicolor"
}
