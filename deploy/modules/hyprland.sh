#-------------------------------------------------------------------------------
# Deploy hyprland configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/local/opt/shell-utils/fs.sh"


hyprland::install () {
    echo "└> Installing hyprland configuration."

    force_link "$base_dir/config/hypr" "$XDG_CONFIG_HOME/hypr"

    echo "└> Installing hyprland shortcuts."

    mkdir -p "$XDG_BIN_HOME"
    force_link "$base_dir/local/bin/init~hyprland" "$XDG_BIN_HOME/init"
}

hyprland::uninstall () {
    echo "└> Uninstalling hyprland configuration."

    rm "$XDG_CONFIG_HOME/hypr"

    echo "└> Uninstalling hyprland shortcuts."

    rm "$XDG_BIN_HOME/init"
}
