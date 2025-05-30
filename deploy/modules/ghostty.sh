#-------------------------------------------------------------------------------
# Deploy ghostty configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


ghostty::install () {
    echo "└> Installing ghostty configuration."

    ensure_directory "$XDG_CONFIG_HOME/ghostty"
    force_link "$base_dir/config/ghostty/config" "$XDG_CONFIG_HOME/ghostty/config"

    ensure_directory "$XDG_CONFIG_HOME/ghostty/themes"
    esh "$base_dir/config/ghostty/themes/custom-theme~esh" > "$XDG_CONFIG_HOME/ghostty/themes/custom-theme"
}

ghostty::uninstall () {
    echo "└> Uninstalling ghostty configuration."

    rm -r "$XDG_CONFIG_HOME/ghostty"
}
