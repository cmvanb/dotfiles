#-------------------------------------------------------------------------------
# Deploy swayosd configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


swayosd::install() {
    echo "└> Installing swayosd configuration."

    local src="$base_dir/modules/swayosd/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/swayosd"
    template::render_mako "$src/style.mako.css" "$XDG_CONFIG_HOME/swayosd/style.css"

    fs::ensure_directory "$XDG_CONFIG_HOME/systemd/user"
    fs::force_link "$src/swayosd-server.service" "$XDG_CONFIG_HOME/systemd/user/swayosd-server.service"
}

swayosd::uninstall() {
    echo "└> Uninstalling swayosd configuration."

    rm "$XDG_CONFIG_HOME/swayosd/style.css"
    rmdir --ignore-fail-on-non-empty "$XDG_CONFIG_HOME/swayosd"
    rm "$XDG_CONFIG_HOME/systemd/user/swayosd-server.service"
}

swayosd::enable() {
    echo "└> Enabling swayosd server service."

    systemctl --user enable swayosd-server
}

swayosd::disable() {
    echo "└> Disabling swayosd server service."

    systemctl --user disable swayosd-server
}
