#-------------------------------------------------------------------------------
# Deploy alacritty configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")


alacritty::install () {
    echo "└> Installing alacritty configuration."

    local src="$base_dir/modules/alacritty/src"

    ensure_directory "$XDG_CONFIG_HOME/alacritty"
    # TODO: Extract templating to a shared function.
    esh "$src/alacritty.toml~esh" > "$XDG_CONFIG_HOME/alacritty/alacritty.toml"
}

alacritty::uninstall () {
    echo "└> Uninstalling alacritty configuration."

    rm -r "$XDG_CONFIG_HOME/alacritty"
}
