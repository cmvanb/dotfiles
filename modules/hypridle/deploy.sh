#-------------------------------------------------------------------------------
# Deploy hypridle configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


hypridle::install () {
    echo "└> Installing hypridle configuration."

    local src="$base_dir/modules/hypridle/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/hypr"
    template::render_mako "$src/hypridle.mako.conf" "$XDG_CONFIG_HOME/hypr/hypridle.conf"

    if systemctl --user is-active --quiet hypridle; then
        echo "└> Restarting running hypridle daemon."
        systemctl --user restart hypridle
    fi
}

hypridle::uninstall () {
    echo "└> Uninstalling hypridle configuration."

    fs::remove "$XDG_CONFIG_HOME/hypr/hypridle.conf"
}

hypridle::enable () {
    echo "└> Enabling hypridle user service."

    systemctl --user enable hypridle
}

hypridle::disable () {
    echo "└> Disabling hypridle user service."

    systemctl --user disable hypridle
}
