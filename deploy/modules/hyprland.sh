#-------------------------------------------------------------------------------
# Deploy hyprland configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


hyprland::install () {
    echo "└> Installing hyprland configuration."

    ensure_directory "$XDG_CONFIG_HOME/hypr"
    force_link "$base_dir/config/hyprland/hyprland.conf" "$XDG_CONFIG_HOME/hypr/hyprland.conf"

    echo "└> Installing hyprland shortcuts."

    ensure_directory "$XDG_BIN_HOME"
    force_link "$base_dir/config/hyprland/init~hyprland" "$XDG_BIN_HOME/init"
}

hyprland::uninstall () {
    echo "└> Uninstalling hyprland configuration."

    rm -r "$XDG_CONFIG_HOME/hypr"

    echo "└> Uninstalling hyprland shortcuts."

    rm "$XDG_BIN_HOME/init"
}
