#-------------------------------------------------------------------------------
# Deploy herdr configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


herdr::install() {
    echo "└> Installing herdr configuration."

    local src="$base_dir/modules/herdr/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/herdr"
    template::render_mako "$src/config.mako.toml" "$XDG_CONFIG_HOME/herdr/config.toml"
}

herdr::uninstall() {
    echo "└> Uninstalling herdr configuration."

    rm "$XDG_CONFIG_HOME/herdr/config.toml"
}
