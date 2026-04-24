#-------------------------------------------------------------------------------
# Deploy opencode configuration
#-------------------------------------------------------------------------------

script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"

opencode::install () {
    echo "└> Installing opencode configuration."

    local src="$base_dir/modules/opencode/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/opencode"
    fs::force_link "$src/opencode.json" "$XDG_CONFIG_HOME/opencode/opencode.json"
    fs::force_link "$src/tui.json" "$XDG_CONFIG_HOME/opencode/tui.json"

    fs::ensure_directory "$XDG_CONFIG_HOME/opencode/themes"
    template::render_mako "$src/themes/carbon-dark.mako.json" "$XDG_CONFIG_HOME/opencode/themes/carbon-dark.json"
}

opencode::uninstall () {
    echo "└> Uninstalling opencode configuration."

    rm "$XDG_CONFIG_HOME/opencode/opencode.json"
    rm "$XDG_CONFIG_HOME/opencode/tui.json"
    rm "$XDG_CONFIG_HOME/opencode/themes/carbon-dark.json"
}
