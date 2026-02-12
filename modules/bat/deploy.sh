#-------------------------------------------------------------------------------
# Deploy bat configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/modules/lib-shell-utils/src/debug.sh"
source "$base_dir/modules/lib-shell-utils/src/fs.sh"


bat::install () {
    assert_dependency bat

    echo "└> Installing bat configuration."

    local src="$base_dir/modules/bat/src"

    ensure_directory "$XDG_CONFIG_HOME/bat"
    force_link "$src/config" "$XDG_CONFIG_HOME/bat/config"
    force_link "$src/syntaxes" "$XDG_CONFIG_HOME/bat/syntaxes"

    ensure_directory "$XDG_CONFIG_HOME/bat/themes"
    esh "$base_dir/modules/theme/src/carbon-dark.tmTheme~esh" > "$XDG_CONFIG_HOME/bat/themes/carbon-dark.tmTheme"

    bat cache --build
}

bat::uninstall () {
    echo "└> Uninstalling bat configuration."

    rm -r "$XDG_CONFIG_HOME/bat"
}
