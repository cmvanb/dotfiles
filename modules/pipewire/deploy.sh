#-------------------------------------------------------------------------------
# Deploy pipewire configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


pipewire::install () {
    echo "└> Installing pipewire configuration."

    local src="$base_dir/modules/pipewire/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/alsa"
    fs::force_link "$src/asoundrc" "$XDG_CONFIG_HOME/alsa/asoundrc"

    # Packaged icons win lookups by name, so the user desktop entry shadows
    # the system one and points at a distinctly named icon.
    fs::ensure_directory "$XDG_DATA_HOME/icons/hicolor/scalable/apps"
    fs::force_link "$src/icons/pavucontrol-mixer.svg" "$XDG_DATA_HOME/icons/hicolor/scalable/apps/pavucontrol-mixer.svg"
    gtk-update-icon-cache -q -f -t "$XDG_DATA_HOME/icons/hicolor"
    fs::ensure_directory "$XDG_DATA_HOME/applications"
    sed 's/^Icon=.*/Icon=pavucontrol-mixer/' /usr/share/applications/org.pulseaudio.pavucontrol.desktop \
        > "$XDG_DATA_HOME/applications/org.pulseaudio.pavucontrol.desktop"
}

pipewire::uninstall () {
    echo "└> Uninstalling pipewire configuration."

    rm -f "$XDG_CONFIG_HOME/alsa/asoundrc"
    rm -f "$XDG_DATA_HOME/icons/hicolor/scalable/apps/pavucontrol-mixer.svg"
    gtk-update-icon-cache -q -f -t "$XDG_DATA_HOME/icons/hicolor"
    rm -f "$XDG_DATA_HOME/applications/org.pulseaudio.pavucontrol.desktop"
    rmdir --ignore-fail-on-non-empty "$XDG_CONFIG_HOME/alsa"
}

pipewire::enable () {
    echo "└> Enabling pipewire user service."

    systemctl --user enable pipewire
}

pipewire::disable () {
    echo "└> Disabling pipewire user service."

    systemctl --user disable pipewire
}
