#-------------------------------------------------------------------------------
# Deploy kanata configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


kanata::install() {
    echo "└> Installing kanata configuration."

    local src="$base_dir/modules/kanata/src"

    ensure_directory "$XDG_CONFIG_HOME/kanata"
    force_link "$src/kanata.kbd" "$XDG_CONFIG_HOME/kanata/kanata.kbd"

    ensure_directory "$XDG_CONFIG_HOME/systemd/user"
    force_link "$src/kanata.service" "$XDG_CONFIG_HOME/systemd/user/kanata.service"
}

kanata::uninstall() {
    echo "└> Uninstalling kanata configuration."

    rm "$XDG_CONFIG_HOME/kanata/kanata.kbd"
    rmdir --ignore-fail-on-non-empty "$XDG_CONFIG_HOME/kanata"
    rm "$XDG_CONFIG_HOME/systemd/user/kanata.service"
}

kanata::enable() {
    echo "└> Enabling kanata user service."

    systemctl --user enable kanata
}

kanata::disable() {
    echo "└> Disabling kanata user service."

    systemctl --user disable kanata
}
