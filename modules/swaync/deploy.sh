#-------------------------------------------------------------------------------
# Deploy swaync configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


swaync::install() {
    echo "└> Installing swaync configuration."

    local src="$base_dir/modules/swaync/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/swaync"
    template::render_mako "$src/config.mako.json" "$XDG_CONFIG_HOME/swaync/config.json"
    template::render_mako "$src/style.mako.css" "$XDG_CONFIG_HOME/swaync/style.css"

    if systemctl --user is-active --quiet swaync; then
        echo "└> Reloading running swaync."
        swaync-client --reload-config --reload-css > /dev/null
    fi
}

swaync::uninstall() {
    echo "└> Uninstalling swaync configuration."

    rm -r "$XDG_CONFIG_HOME/swaync"
}

swaync::enable() {
    echo "└> Enabling swaync service."

    systemctl --user enable swaync
}

swaync::disable() {
    echo "└> Disabling swaync service."

    systemctl --user disable swaync
}
