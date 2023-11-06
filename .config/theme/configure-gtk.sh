#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# GTK theme configuration
#-------------------------------------------------------------------------------

# Retrieve system theme vars
source "$XDG_CONFIG_HOME/theme/fonts"

# see: https://github.com/vinceliuice/Qogir-theme
gsettings set org.gnome.desktop.interface gtk-theme 'Qogir-Dark'

# TODO: Improve default icons. Install icons to `.local/share/icons`.
# gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'

gsettings set org.gnome.desktop.interface font-name "$font_sans 12"
gsettings set org.gnome.desktop.interface document-font-name "$font_sans 12"
gsettings set org.gnome.desktop.interface monospace-font-name "$font_mono 13"
gsettings set org.gnome.desktop.interface cursor-theme "Simp1e"

# Show hidden files in file dialog.
gsettings set org.gtk.Settings.FileChooser show-hidden true
