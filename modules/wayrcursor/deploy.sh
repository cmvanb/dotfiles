#-------------------------------------------------------------------------------
# Deploy wayrcursor configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


wayrcursor::install () {
    echo "└> Installing wayrcursor configuration."

    local src="$base_dir/modules/wayrcursor/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/wayrcursor"
    template::render_mako "$src/config.mako.toml" "$XDG_CONFIG_HOME/wayrcursor/config.toml"
}

wayrcursor::uninstall () {
    echo "└> Uninstalling wayrcursor configuration."

    rm "$XDG_CONFIG_HOME/wayrcursor/config.toml"
    rmdir --ignore-fail-on-non-empty "$XDG_CONFIG_HOME/wayrcursor"
}

wayrcursor::enable () {
    echo "└> Enabling wayrcursor user service."

    systemctl --user enable wayrcursor
}

wayrcursor::disable () {
    echo "└> Disabling wayrcursor user service."

    systemctl --user disable wayrcursor
}
