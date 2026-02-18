#-------------------------------------------------------------------------------
# Deploy wezterm configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


wezterm::install () {
    echo "└> Installing wezterm configuration."

    local src="$base_dir/modules/wezterm/src"

    ensure_directory "$XDG_CONFIG_HOME/wezterm"
    force_link "$src/wezterm.lua" "$XDG_CONFIG_HOME/wezterm/wezterm.lua"
}

wezterm::uninstall () {
    echo "└> Uninstalling wezterm configuration."

    rm -r "$XDG_CONFIG_HOME/wezterm"
}
