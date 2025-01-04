#-------------------------------------------------------------------------------
# Deploy hyprland configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


hyprland::install () {
    echo "└> Installing hyprland configuration."

    force_link "$base_dir/config/hypr" "$config_dir/hypr"
}

hyprland::uninstall () {
    echo "└> Uninstalling hyprland configuration."

    rm "$config_dir/hypr"
}
