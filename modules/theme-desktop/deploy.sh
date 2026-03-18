#-------------------------------------------------------------------------------
# Deploy theme desktop configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


theme-desktop::install_gtk_theme () {
    echo "└> Installing GTK theme."

    # Install GTK settings files
    local src="$base_dir/modules/theme-desktop/src"

    ensure_directory "$XDG_CONFIG_HOME/gtk-3.0"
    ensure_directory "$XDG_CONFIG_HOME/gtk-4.0"

    render_esh_template "$src/gtk-4.0-gtk.esh.css"               "$XDG_CONFIG_HOME/gtk-4.0/gtk.css"
    render_esh_template "$src/gtk-3.0-settings.esh.ini"          "$XDG_CONFIG_HOME/gtk-3.0/settings.ini"
    render_esh_template "$src/gtk-4.0-settings.esh.ini"          "$XDG_CONFIG_HOME/gtk-4.0/settings.ini"

    # Install GTK CSS files
    local theme_src="$src/carbon-dark-gtk"
    local theme_dest="$HOME/.local/share/themes/carbon-dark-gtk"

    ensure_directory "$theme_dest"
    ensure_directory "$theme_dest/gtk-3.0"
    ensure_directory "$theme_dest/gtk-4.0"

    force_link "$theme_src/index.theme" "$theme_dest/index.theme"

    force_link "$theme_src/gtk-3.0/libadwaita-tweaks.css" "$theme_dest/gtk-3.0/libadwaita-tweaks.css"
    force_link "$theme_src/gtk-3.0/gtk.css"               "$theme_dest/gtk-3.0/gtk.css"
    force_link "$theme_src/gtk-3.0/gtk-dark-widgets.css"  "$theme_dest/gtk-3.0/gtk-dark-widgets.css"
    force_link "$theme_src/gtk-3.0/assets"                "$theme_dest/gtk-3.0/assets"

    force_link "$theme_src/gtk-4.0/gtk.css"               "$theme_dest/gtk-4.0/gtk.css"
    force_link "$theme_src/gtk-4.0/libadwaita-tweaks.css" "$theme_dest/gtk-4.0/libadwaita-tweaks.css"
    force_link "$theme_src/gtk-4.0/libadwaita-head.css"   "$theme_dest/gtk-4.0/libadwaita-head.css"
    force_link "$theme_src/gtk-4.0/libadwaita-tail.css"   "$theme_dest/gtk-4.0/libadwaita-tail.css"

    # Render CSS templates
    # NOTE: Export fragment path so the libadwaita ESH template can reference them.
    export CARBON_GTK4_SRC="$theme_src/gtk-4.0"

    render_esh_template "$theme_src/gtk-3.0/gtk-dark.esh.css"   "$theme_dest/gtk-3.0/gtk-dark.css"
    render_esh_template "$theme_src/gtk-4.0/libadwaita.esh.css" "$theme_dest/gtk-4.0/libadwaita.css"
}

theme-desktop::configure_gtk () {
    echo "└> Configuring GTK."

    # shellcheck disable=SC1091
    source "$XDG_CACHE_HOME/theme/theme-data.sh"

    # Select GTK theme.
    gsettings set org.gnome.desktop.interface gtk-theme 'carbon-dark-gtk'
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

    # see: https://github.com/yeyushengfan258/Win11-icon-theme
    gsettings set org.gnome.desktop.interface icon-theme 'Win11-dark'

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

    ensure_directory "$XDG_SCRIPTS_HOME"
    force_link "$base_dir/modules/theme-desktop/src/generate-color-gradient-palette.py" "$XDG_SCRIPTS_HOME/generate-color-gradient-palette.py"

    theme-desktop::install_gtk_theme
    theme-desktop::configure_gtk
}

theme-desktop::uninstall () {
    echo "└> Uninstalling theme desktop configuration."

    rm -f "$XDG_SCRIPTS_HOME/generate-color-gradient-palette.py"

    rm -f "$XDG_CONFIG_HOME/gtk-3.0/settings.ini"
    rm -f "$XDG_CONFIG_HOME/gtk-4.0/gtk.css"
    rm -f "$XDG_CONFIG_HOME/gtk-4.0/settings.ini"

    rm -rf "$HOME/.local/share/themes/carbon-dark-gtk"

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
