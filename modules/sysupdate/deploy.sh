#-------------------------------------------------------------------------------
# Deploy sysupdate configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


sysupdate::install () {
    echo "└> Installing sysupdate configuration."

    local src="$base_dir/modules/sysupdate/src"

    fs::ensure_directory "$XDG_BIN_HOME"
    fs::force_link "$src/sysupdate" "$XDG_BIN_HOME/sysupdate"

    fs::ensure_directory "$XDG_CONFIG_HOME/systemd/user"
    fs::force_link "$src/sysupdate-check.service" "$XDG_CONFIG_HOME/systemd/user/sysupdate-check.service"
    fs::force_link "$src/sysupdate-check.timer" "$XDG_CONFIG_HOME/systemd/user/sysupdate-check.timer"
    fs::force_link "$src/sysupdate-watch.path" "$XDG_CONFIG_HOME/systemd/user/sysupdate-watch.path"
}

sysupdate::uninstall () {
    echo "└> Uninstalling sysupdate configuration."

    fs::remove "$XDG_BIN_HOME/sysupdate"
    fs::remove "$XDG_CONFIG_HOME/systemd/user/sysupdate-check.service"
    fs::remove "$XDG_CONFIG_HOME/systemd/user/sysupdate-check.timer"
    fs::remove "$XDG_CONFIG_HOME/systemd/user/sysupdate-watch.path"
}

sysupdate::enable () {
    echo "└> Enabling sysupdate user units."

    systemctl --user enable sysupdate-check.timer sysupdate-watch.path
}

sysupdate::disable () {
    echo "└> Disabling sysupdate user units."

    systemctl --user disable sysupdate-check.timer sysupdate-watch.path
}
