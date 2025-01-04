#-------------------------------------------------------------------------------
# Deploy waybar configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


waybar::install () {
    echo "└> Installing waybar configuration."

    # TODO: Extract WM-specific configuration to WM modules.
    mkdir -p "$config_dir/waybar"
    force_link "$base_dir/config/waybar/niri-config" "$config_dir/waybar/config"
    esh "$base_dir/config/waybar/niri-style.css~esh" > "$config_dir/waybar/style.css"
}

waybar::uninstall () {
    echo "└> Uninstalling waybar configuration."

    rm "$config_dir/waybar"
}
