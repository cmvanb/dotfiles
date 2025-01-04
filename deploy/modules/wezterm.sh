#-------------------------------------------------------------------------------
# Deploy wezterm configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


wezterm::install () {
    echo "└> Installing wezterm configuration."

    mkdir -p "$config_dir/wezterm"
    force_link "$base_dir/config/wezterm/wezterm.lua" "$config_dir/wezterm/wezterm.lua"
}

wezterm::uninstall () {
    echo "└> Uninstalling wezterm configuration."

    rm -r "$config_dir/wezterm"
}
