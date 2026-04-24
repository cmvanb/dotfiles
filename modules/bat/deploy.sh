#-------------------------------------------------------------------------------
# Deploy bat configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/debug.sh"
source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


bat::install () {
    debug::assert_dependency bat

    echo "└> Installing bat configuration."

    local src="$base_dir/modules/bat/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/bat"
    fs::force_link "$src/config" "$XDG_CONFIG_HOME/bat/config"
    fs::force_link "$src/syntaxes" "$XDG_CONFIG_HOME/bat/syntaxes"

    fs::ensure_directory "$XDG_CONFIG_HOME/bat/themes"
    template::render_mako "$base_dir/modules/theme-base/src/carbon-dark.syntect.mako.tmTheme" "$XDG_CONFIG_HOME/bat/themes/carbon-dark.tmTheme"

    bat cache --build
}

bat::uninstall () {
    echo "└> Uninstalling bat configuration."

    rm -r "$XDG_CONFIG_HOME/bat"
}
