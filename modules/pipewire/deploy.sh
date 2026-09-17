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
}

pipewire::uninstall () {
    echo "└> Uninstalling pipewire configuration."

    rm -f "$XDG_CONFIG_HOME/alsa/asoundrc"
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
