#-------------------------------------------------------------------------------
# Deploy ghostty configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


ghostty::install () {
    echo "└> Installing ghostty configuration."

    local src="$base_dir/modules/ghostty/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/ghostty"
    template::render_mako "$src/config.mako" "$XDG_CONFIG_HOME/ghostty/config"

    fs::ensure_directory "$XDG_CONFIG_HOME/ghostty/themes"
    template::render_mako "$src/themes/custom-theme.mako" "$XDG_CONFIG_HOME/ghostty/themes/custom-theme"
}

ghostty::uninstall () {
    echo "└> Uninstalling ghostty configuration."

    rm -r "$XDG_CONFIG_HOME/ghostty"
}
