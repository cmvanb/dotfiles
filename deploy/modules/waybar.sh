#-------------------------------------------------------------------------------
# Deploy waybar configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/local/opt/shell-utils/fs.sh"


waybar::install () {
    echo "└> Installing waybar configuration."

    # TODO: Extract WM-specific configuration to WM modules.
    mkdir -p "$XDG_CONFIG_HOME/waybar"
    force_link "$base_dir/config/waybar/niri-config" "$XDG_CONFIG_HOME/waybar/config"
    esh "$base_dir/config/waybar/niri-style.css~esh" > "$XDG_CONFIG_HOME/waybar/style.css"
}

waybar::uninstall () {
    echo "└> Uninstalling waybar configuration."

    rm "$XDG_CONFIG_HOME/waybar"
}
