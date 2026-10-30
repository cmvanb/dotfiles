#-------------------------------------------------------------------------------
# Deploy justpager configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/debug.sh"
source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


justpager::install () {
    debug::assert_dependency justpager

    echo "└> Installing justpager configuration."

    local src="$base_dir/modules/justpager/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/justpager/themes"
    fs::force_link "$src/config.toml" "$XDG_CONFIG_HOME/justpager/config.toml"
    template::render_mako "$src/carbon.mako.toml" "$XDG_CONFIG_HOME/justpager/themes/carbon.toml"
}

justpager::uninstall () {
    echo "└> Uninstalling justpager configuration."

    rm -r "$XDG_CONFIG_HOME/justpager"
}
