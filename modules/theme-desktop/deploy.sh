#-------------------------------------------------------------------------------
# Deploy theme desktop configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"

theme-desktop::configure_gtk () {
    echo "└> Configuring GTK."

    # shellcheck disable=SC1091
    source "$XDG_CACHE_HOME/theme/theme-data.sh"

    # see: https://github.com/vinceliuice/Qogir-theme
    gsettings set org.gnome.desktop.interface gtk-theme 'Qogir-Round-Dark'

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

    theme-desktop::configure_gtk
}

theme-desktop::uninstall () {
    echo "└> Uninstalling theme desktop configuration."

    rm -f "$XDG_SCRIPTS_HOME/generate-color-gradient-palette.py"
}
