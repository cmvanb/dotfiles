#-------------------------------------------------------------------------------
# Deploy theme desktop configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"

# Every variant is installed so `theme switch` only has to select one.
theme_desktop_variants=(dark light)


theme-desktop::install_icons () {
    echo "└> Installing icon overrides."

    local icons_src="$base_dir/modules/theme-desktop/src/icons"

    # The symbolic overrides are recolored by GTK, so both variants share them.
    local variant
    for variant in "${theme_desktop_variants[@]}"; do
        local icons_dest="$XDG_DATA_HOME/icons/carbon-$variant"

        fs::ensure_directory "$icons_dest/scalable/actions"
        fs::ensure_directory "$icons_dest/scalable/status"
        fs::force_link "$icons_src/carbon-$variant/index.theme" "$icons_dest/index.theme"
        fs::force_link "$icons_src/carbon-dark/scalable/actions/sink-volume-medium-symbolic.svg"  "$icons_dest/scalable/actions/sink-volume-medium-symbolic.svg"
        fs::force_link "$icons_src/carbon-dark/scalable/actions/source-volume-muted-symbolic.svg" "$icons_dest/scalable/actions/source-volume-muted-symbolic.svg"
        theme-desktop::install_status_icons "$variant" "$icons_dest/scalable/status"
        theme-desktop::install_battery_icons "$variant" "$icons_dest/scalable/status"
    done
}

# Win11 also ships its symbolic status names as fixed 22 and 24px panel icons
# with a larger canvas. GTK prefers those at 17 to 24px on a scale 1 output, so
# icons render oversized and clipped. Links in a scalable directory of the
# overriding theme always win.
theme-desktop::install_status_icons () {
    local variant=$1 dest=$2
    local base_theme=Win11
    [[ $variant == dark ]] && base_theme=Win11-dark

    local icon
    for icon in /usr/share/icons/"$base_theme"/status/symbolic/*-symbolic.svg; do
        [[ ${icon##*/} == battery-level-* ]] && continue
        fs::force_link "$icon" "$dest/${icon##*/}"
    done
}

# The battery fill hard-codes its fill or state class, so GTK recolors it
# independently of the text color. Copies without them follow the module's
# state color like the rest of the icon.
theme-desktop::install_battery_icons () {
    local variant=$1 dest=$2
    local base_theme=Win11
    [[ $variant == dark ]] && base_theme=Win11-dark

    local icon
    for icon in /usr/share/icons/"$base_theme"/status/symbolic/battery-level-*-symbolic.svg; do
        rm -f "$dest/${icon##*/}"
        sed -E '/<(path|rect)/{s/ fill="#[0-9a-fA-F]{3,6}"//; s/ class="(success|warning|error)"//}' "$icon" > "$dest/${icon##*/}"
    done
}

theme-desktop::install_gtk_theme () {
    echo "└> Installing GTK theme."

    git -C "$base_dir" submodule update --init modules/theme-desktop/src/carbon-gtk

    # Install GTK settings files
    local src="$base_dir/modules/theme-desktop/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/gtk-3.0"
    fs::ensure_directory "$XDG_CONFIG_HOME/gtk-4.0"

    template::render_mako "$src/gtk-4.0-gtk.mako.css"      "$XDG_CONFIG_HOME/gtk-4.0/gtk.css"
    template::render_mako "$src/gtk-3.0-settings.mako.ini" "$XDG_CONFIG_HOME/gtk-3.0/settings.ini"
    template::render_mako "$src/gtk-4.0-settings.mako.ini" "$XDG_CONFIG_HOME/gtk-4.0/settings.ini"

    # Install GTK CSS files. Static files and templates are shared; each variant
    # brings its own index and Adwaita widget base.
    local shared_src="$src/carbon-gtk/carbon-dark-gtk"

    local variant
    for variant in "${theme_desktop_variants[@]}"; do
        local theme_src="$src/carbon-gtk/carbon-$variant-gtk"
        local theme_dest="$XDG_DATA_HOME/themes/carbon-$variant-gtk"

        fs::ensure_directory "$theme_dest"
        fs::ensure_directory "$theme_dest/gtk-3.0"
        fs::ensure_directory "$theme_dest/gtk-4.0"

        fs::force_link "$theme_src/index.theme" "$theme_dest/index.theme"

        # GTK3: static assets + widget CSS (symlinked); color palette + dark variant (rendered)
        fs::force_link "$shared_src/gtk-3.0/libadwaita-tweaks.css"           "$theme_dest/gtk-3.0/libadwaita-tweaks.css"
        fs::force_link "$theme_src/gtk-3.0/gtk-$variant-widgets.css"         "$theme_dest/gtk-3.0/gtk-$variant-widgets.css"
        fs::force_link "$shared_src/gtk-3.0/assets"                          "$theme_dest/gtk-3.0/assets"

        # GTK4: tail and tweaks are symlinked (static); libadwaita is rendered with full palette inline
        fs::force_link "$shared_src/gtk-4.0/gtk.css"               "$theme_dest/gtk-4.0/gtk.css"
        fs::force_link "$shared_src/gtk-4.0/libadwaita-tweaks.css" "$theme_dest/gtk-4.0/libadwaita-tweaks.css"
        fs::force_link "$shared_src/gtk-4.0/libadwaita-tail.css"   "$theme_dest/gtk-4.0/libadwaita-tail.css"

        # Render CSS templates pinned to the variant's scheme
        template::render_mako "$shared_src/gtk-3.0/gtk.mako.css"        "$theme_dest/gtk-3.0/gtk.css"         "carbon-$variant"
        template::render_mako "$shared_src/gtk-3.0/gtk-dark.mako.css"   "$theme_dest/gtk-3.0/gtk-dark.css"    "carbon-$variant"
        template::render_mako "$shared_src/gtk-4.0/libadwaita.mako.css" "$theme_dest/gtk-4.0/libadwaita.css"  "carbon-$variant"
    done
}

theme-desktop::install_qt_theme () {
    echo "└> Installing Qt theme."

    git -C "$base_dir" submodule update --init modules/theme-desktop/src/carbon-qt

    local src="$base_dir/modules/theme-desktop/src"
    local theme_src="$src/carbon-qt"

    fs::ensure_directory "$XDG_CONFIG_HOME/qt6ct"
    fs::ensure_directory "$XDG_DATA_HOME/qt6ct/colors"
    fs::ensure_directory "$XDG_DATA_HOME/qt6ct/qss"

    # Settings follow the active scheme, so `theme switch` re-renders them and
    # qt6ct restyles running apps.
    template::render_mako "$src/qt6ct.mako.conf" "$XDG_CONFIG_HOME/qt6ct/qt6ct.conf"

    local variant
    for variant in "${theme_desktop_variants[@]}"; do
        template::render_mako "$theme_src/colors/carbon.mako.conf" "$XDG_DATA_HOME/qt6ct/colors/carbon-$variant.conf" "carbon-$variant"
        template::render_mako "$theme_src/qss/carbon.mako.qss"     "$XDG_DATA_HOME/qt6ct/qss/carbon-$variant.qss"    "carbon-$variant"
        python "$theme_src/generate-icons.py" "$variant" "$XDG_DATA_HOME/icons/carbon-$variant-qt"
    done
}

theme-desktop::configure_gtk () {
    echo "└> Configuring GTK."

    # shellcheck disable=SC1091
    source "$XDG_CACHE_HOME/theme/theme-data.sh"

    # Select GTK theme. GTK_THEME in the session environment names the stable
    # `carbon-gtk` alias, which `theme switch` repoints.
    ln -sfn "carbon-$scheme_variant-gtk" "$XDG_DATA_HOME/themes/carbon-gtk"
    gsettings set org.gnome.desktop.interface gtk-theme "carbon-$scheme_variant-gtk"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-$scheme_variant"

    # see: https://github.com/yeyushengfan258/Win11-icon-theme
    gsettings set org.gnome.desktop.interface icon-theme "carbon-$scheme_variant"

    gsettings set org.gnome.desktop.interface font-name "$font_sans $font_size_medium"
    gsettings set org.gnome.desktop.interface document-font-name "$font_sans $font_size_medium"
    gsettings set org.gnome.desktop.interface monospace-font-name "$font_mono $font_size_large"
    gsettings set org.gnome.desktop.interface cursor-theme "$cursor_theme"
    gsettings set org.gnome.desktop.interface cursor-size "$cursor_size"

    # Show hidden files in file dialog.
    gsettings set org.gtk.Settings.FileChooser show-hidden true
}

theme-desktop::install () {
    echo "└> Installing theme desktop configuration."

    fs::ensure_directory "$XDG_SCRIPTS_HOME"
    fs::force_link "$base_dir/modules/theme-desktop/src/generate-color-gradient-palette.py"   "$XDG_SCRIPTS_HOME/generate-color-gradient-palette.py"
    fs::force_link "$base_dir/modules/theme-desktop/src/generate-contrast-mirror-palette.py" "$XDG_SCRIPTS_HOME/generate-contrast-mirror-palette.py"

    theme-desktop::install_icons
    theme-desktop::install_gtk_theme
    theme-desktop::install_qt_theme
    theme-desktop::configure_gtk
}

theme-desktop::uninstall () {
    echo "└> Uninstalling theme desktop configuration."

    rm -f "$XDG_SCRIPTS_HOME/generate-color-gradient-palette.py"
    rm -f "$XDG_SCRIPTS_HOME/generate-contrast-mirror-palette.py"

    rm -f "$XDG_CONFIG_HOME/gtk-3.0/settings.ini"
    rm -f "$XDG_CONFIG_HOME/gtk-4.0/gtk.css"
    rm -f "$XDG_CONFIG_HOME/gtk-4.0/settings.ini"

    rm -f "$XDG_DATA_HOME/themes/carbon-gtk"

    rm -f "$XDG_CONFIG_HOME/qt6ct/qt6ct.conf"
    rmdir "$XDG_CONFIG_HOME/qt6ct" 2>/dev/null || true

    local variant
    for variant in "${theme_desktop_variants[@]}"; do
        rm -rf "$XDG_DATA_HOME/icons/carbon-$variant"
        rm -rf "$XDG_DATA_HOME/icons/carbon-$variant-qt"
        rm -rf "$XDG_DATA_HOME/themes/carbon-$variant-gtk"
        rm -f "$XDG_DATA_HOME/qt6ct/colors/carbon-$variant.conf"
        rm -f "$XDG_DATA_HOME/qt6ct/qss/carbon-$variant.qss"
    done
    rmdir "$XDG_DATA_HOME/qt6ct/colors" "$XDG_DATA_HOME/qt6ct/qss" "$XDG_DATA_HOME/qt6ct" 2>/dev/null || true

    gsettings reset org.gnome.desktop.interface gtk-theme
    gsettings reset org.gnome.desktop.interface color-scheme
    gsettings reset org.gnome.desktop.interface icon-theme
    gsettings reset org.gnome.desktop.interface font-name
    gsettings reset org.gnome.desktop.interface document-font-name
    gsettings reset org.gnome.desktop.interface monospace-font-name
    gsettings reset org.gnome.desktop.interface cursor-theme
    gsettings reset org.gnome.desktop.interface cursor-size
    gsettings reset org.gtk.Settings.FileChooser show-hidden
}
