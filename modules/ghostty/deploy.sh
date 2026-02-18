#-------------------------------------------------------------------------------
# Deploy ghostty configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


ghostty::install () {
    echo "└> Installing ghostty configuration."

    local src="$base_dir/modules/ghostty/src"

    ensure_directory "$XDG_CONFIG_HOME/ghostty"
    force_link "$src/config" "$XDG_CONFIG_HOME/ghostty/config"

    ensure_directory "$XDG_CONFIG_HOME/ghostty/themes"
    esh "$src/themes/custom-theme~esh" > "$XDG_CONFIG_HOME/ghostty/themes/custom-theme"
}

ghostty::uninstall () {
    echo "└> Uninstalling ghostty configuration."

    rm -r "$XDG_CONFIG_HOME/ghostty"
}
