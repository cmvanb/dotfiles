#-------------------------------------------------------------------------------
# Deploy alacritty configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}


alacritty::install () {
    echo "└> Installing alacritty configuration."

    mkdir -p "$config_dir/alacritty"

    # TODO: Extract templating to a shared function.
    esh "$base_dir/config/alacritty/alacritty.toml~esh" > "$config_dir/alacritty/alacritty.toml"
}

alacritty::uninstall () {
    echo "└> Uninstalling alacritty configuration."

    rm -r "$config_dir/alacritty"
}
