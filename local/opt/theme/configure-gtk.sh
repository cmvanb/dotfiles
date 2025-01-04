#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# GTK theme configuration
#-------------------------------------------------------------------------------

# Retrieve system theme vars
# shellcheck disable=SC1091
source "$XDG_CONFIG_HOME/theme/fonts"
source "$XDG_CONFIG_HOME/theme/cursor"

# see: https://github.com/vinceliuice/Qogir-theme
gsettings set org.gnome.desktop.interface gtk-theme 'Qogir-Dark'

# TODO: Improve default icons. Install icons to `.local/share/icons`.
# gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'

gsettings set org.gnome.desktop.interface font-name "$font_sans $font_size_medium"
gsettings set org.gnome.desktop.interface document-font-name "$font_sans $font_size_medium"
gsettings set org.gnome.desktop.interface monospace-font-name "$font_mono $font_size_large"
gsettings set org.gnome.desktop.interface cursor-theme "$cursor_theme"
gsettings set org.gnome.desktop.interface cursor-size "$cursor_size"

# Show hidden files in file dialog.
gsettings set org.gtk.Settings.FileChooser show-hidden true
