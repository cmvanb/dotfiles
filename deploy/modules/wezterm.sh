#-------------------------------------------------------------------------------
# Deploy wezterm configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


wezterm::install () {
    echo "└> Installing wezterm configuration."

    ensure_directory "$XDG_CONFIG_HOME/wezterm"
    force_link "$base_dir/config/wezterm/wezterm.lua" "$XDG_CONFIG_HOME/wezterm/wezterm.lua"
}

wezterm::uninstall () {
    echo "└> Uninstalling wezterm configuration."

    rm -r "$XDG_CONFIG_HOME/wezterm"
}
