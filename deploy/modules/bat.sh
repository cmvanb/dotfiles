#-------------------------------------------------------------------------------
# Deploy bat configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/debug.sh"
source "$base_dir/local/opt/shell-utils/fs.sh"


bat::install () {
    assert_dependency bat

    echo "└> Installing bat configuration."

    mkdir -p "$config_dir/bat"
    force_link "$base_dir/config/bat/config" "$config_dir/bat/config"
    force_link "$base_dir/config/bat/syntaxes" "$config_dir/bat/syntaxes"

    mkdir -p "$config_dir/bat/themes"
    esh "$base_dir/config/theme/carbon-dark.tmTheme~esh" > "$config_dir/bat/themes/carbon-dark.tmTheme"

    bat cache --build
}

bat::uninstall () {
    echo "└> Uninstalling bat configuration."

    rm -r "$config_dir/bat"
}
