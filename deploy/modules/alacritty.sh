#-------------------------------------------------------------------------------
# Deploy alacritty configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")


alacritty::install () {
    echo "└> Installing alacritty configuration."

    mkdir -p "$XDG_CONFIG_HOME/alacritty"
    # TODO: Extract templating to a shared function.
    esh "$base_dir/config/alacritty/alacritty.toml~esh" > "$XDG_CONFIG_HOME/alacritty/alacritty.toml"
}

alacritty::uninstall () {
    echo "└> Uninstalling alacritty configuration."

    rm -r "$XDG_CONFIG_HOME/alacritty"
}
