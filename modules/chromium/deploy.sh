#-------------------------------------------------------------------------------
# Deploy chromium configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


chromium::install () {
    echo "└> Installing chromium configuration."

    local src="$base_dir/modules/chromium/src"

    fs::ensure_directory "$XDG_DATA_HOME/applications"
    fs::force_link "$src/chromium.desktop" "$XDG_DATA_HOME/applications/chromium.desktop"
    fs::force_link "$src/netflix.desktop" "$XDG_DATA_HOME/applications/netflix.desktop"

    fs::ensure_directory "$XDG_DATA_HOME/icons/hicolor/64x64/apps"
    fs::force_link "$src/netflix.png" "$XDG_DATA_HOME/icons/hicolor/64x64/apps/netflix.png"

    fs::ensure_directory "$XDG_DATA_HOME/icons/hicolor/scalable/apps"
    fs::force_link "$src/icons/chromium-browser.svg" "$XDG_DATA_HOME/icons/hicolor/scalable/apps/chromium.svg"
    fs::force_link "$src/icons/chromium-browser.svg" "$XDG_DATA_HOME/icons/hicolor/scalable/apps/chromium-browser.svg"

    # The desktop entries select this theme through GTK_THEME. It extends the
    # carbon-gtk alias, so it follows `theme switch` on the next launch.
    local theme_dest="$XDG_DATA_HOME/themes/carbon-chromium-gtk"
    fs::ensure_directory "$theme_dest/gtk-4.0"
    fs::force_link "$src/gtk-4.0/gtk.css" "$theme_dest/gtk-4.0/gtk.css"
    fs::force_link "$XDG_DATA_HOME/themes/carbon-gtk/gtk-3.0" "$theme_dest/gtk-3.0"

    "$src/generate-ui-font.py" "$XDG_DATA_HOME/fonts/nimbus-sans-chromium"
    fc-cache "$XDG_DATA_HOME/fonts/nimbus-sans-chromium"

    fs::force_link "$src/chromium-flags.conf" "$XDG_CONFIG_HOME/chromium-flags.conf"

    fs::ensure_directory "$XDG_CONFIG_HOME/chromium"
    fs::force_link "$src/extensions" "$XDG_CONFIG_HOME/chromium/External Extensions"

    "$src/seed-default-zoom.py" "$XDG_CONFIG_HOME/chromium/Default" --percent 110 || true

    "$src/vimium-c/seed-key-mappings.py" "$XDG_CONFIG_HOME/chromium/Default" \
        --mappings "$src/vimium-c/key-mappings" || true
}

chromium::uninstall () {
    echo "└> Uninstalling chromium configuration."

    rm "$XDG_DATA_HOME/applications/chromium.desktop"
    rm "$XDG_DATA_HOME/applications/netflix.desktop"
    rm "$XDG_DATA_HOME/icons/hicolor/64x64/apps/netflix.png"
    rm "$XDG_DATA_HOME/icons/hicolor/scalable/apps/chromium.svg"
    rm "$XDG_DATA_HOME/icons/hicolor/scalable/apps/chromium-browser.svg"
    rm "$XDG_CONFIG_HOME/chromium/External Extensions"
    rm -rf "$XDG_DATA_HOME/themes/carbon-chromium-gtk"
    rm -rf "$XDG_DATA_HOME/fonts/nimbus-sans-chromium"
    fc-cache
    rm "$XDG_CONFIG_HOME/chromium-flags.conf"

    "$base_dir/modules/chromium/src/seed-default-zoom.py" "$XDG_CONFIG_HOME/chromium/Default" \
        --clear || true

    "$base_dir/modules/chromium/src/vimium-c/seed-key-mappings.py" "$XDG_CONFIG_HOME/chromium/Default" \
        --clear || true
}
