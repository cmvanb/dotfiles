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

    fs::ensure_directory "$XDG_CONFIG_HOME/gtk-3.0"
    fs::ensure_directory "$XDG_CONFIG_HOME/gtk-4.0"

    template::render_mako "$src/gtk-4.0-gtk.mako.css"      "$XDG_CONFIG_HOME/gtk-4.0/gtk.css"
    template::render_mako "$src/gtk-3.0-settings.mako.ini" "$XDG_CONFIG_HOME/gtk-3.0/settings.ini"
    template::render_mako "$src/gtk-4.0-settings.mako.ini" "$XDG_CONFIG_HOME/gtk-4.0/settings.ini"

    # Install GTK CSS files
    local theme_src="$src/carbon-dark-gtk"
    local theme_dest="$HOME/.local/share/themes/carbon-dark-gtk"

    fs::ensure_directory "$theme_dest"
    fs::ensure_directory "$theme_dest/gtk-3.0"
    fs::ensure_directory "$theme_dest/gtk-4.0"

    fs::force_link "$theme_src/index.theme" "$theme_dest/index.theme"

    # GTK3: static assets + widget CSS (symlinked); color palette + dark variant (rendered)
    fs::force_link "$theme_src/gtk-3.0/libadwaita-tweaks.css" "$theme_dest/gtk-3.0/libadwaita-tweaks.css"
    fs::force_link "$theme_src/gtk-3.0/gtk-dark-widgets.css"  "$theme_dest/gtk-3.0/gtk-dark-widgets.css"
    fs::force_link "$theme_src/gtk-3.0/assets"                "$theme_dest/gtk-3.0/assets"

    # GTK4: tail and tweaks are symlinked (static); libadwaita is rendered with full palette inline
    fs::force_link "$theme_src/gtk-4.0/gtk.css"               "$theme_dest/gtk-4.0/gtk.css"
    fs::force_link "$theme_src/gtk-4.0/libadwaita-tweaks.css" "$theme_dest/gtk-4.0/libadwaita-tweaks.css"
    fs::force_link "$theme_src/gtk-4.0/libadwaita-tail.css"   "$theme_dest/gtk-4.0/libadwaita-tail.css"

    # Render CSS templates
    template::render_mako "$theme_src/gtk-3.0/gtk.mako.css"        "$theme_dest/gtk-3.0/gtk.css"
    template::render_mako "$theme_src/gtk-3.0/gtk-dark.mako.css"   "$theme_dest/gtk-3.0/gtk-dark.css"
    template::render_mako "$theme_src/gtk-4.0/libadwaita.mako.css" "$theme_dest/gtk-4.0/libadwaita.css"
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

    fs::ensure_directory "$XDG_SCRIPTS_HOME"
    fs::force_link "$base_dir/modules/theme-desktop/src/generate-color-gradient-palette.py" "$XDG_SCRIPTS_HOME/generate-color-gradient-palette.py"

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
