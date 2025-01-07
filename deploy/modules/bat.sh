#-------------------------------------------------------------------------------
# Deploy bat configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/debug.sh"
source "$base_dir/config/lib-shell-utils/fs.sh"


bat::install () {
    assert_dependency bat

    echo "└> Installing bat configuration."

    ensure_directory "$XDG_CONFIG_HOME/bat"
    force_link "$base_dir/config/bat/config" "$XDG_CONFIG_HOME/bat/config"
    force_link "$base_dir/config/bat/syntaxes" "$XDG_CONFIG_HOME/bat/syntaxes"

    ensure_directory "$XDG_CONFIG_HOME/bat/themes"
    esh "$base_dir/config/theme/carbon-dark.tmTheme~esh" > "$XDG_CONFIG_HOME/bat/themes/carbon-dark.tmTheme"

    bat cache --build
}

bat::uninstall () {
    echo "└> Uninstalling bat configuration."

    rm -r "$XDG_CONFIG_HOME/bat"
}
