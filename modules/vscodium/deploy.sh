#-------------------------------------------------------------------------------
# Deploy vscodium configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/modules/lib-shell-utils/src/fs.sh"
source "$base_dir/modules/lib-shell-utils/src/template.sh"


vscodium::install () {
    echo "└> Installing vscodium configuration."

    local src="$base_dir/modules/vscodium/src"

    ensure_directory "$XDG_DATA_HOME/vscode/user-data/User"
    force_link "$src/keybindings.json" "$XDG_DATA_HOME/vscode/user-data/User/keybindings.json"
    force_link "$src/settings.json" "$XDG_DATA_HOME/vscode/user-data/User/settings.json"

    ensure_directory "$XDG_DATA_HOME/vscode/extensions/custom-theme/themes"
    render_esh_template "$src/theme.json~esh" "$module_config_dir/custom-theme/themes/theme.json"
    force_link "$src/custom-theme" "$XDG_DATA_HOME/vscode/extensions/custom-theme"

    ensure_directory "$XDG_DATA_HOME/applications"
    force_link "$src/vscodium-wayland.desktop" "$XDG_DATA_HOME/applications/vscodium-wayland.desktop"
    force_link "$src/vscodium.desktop" "$XDG_DATA_HOME/applications/vscodium.desktop"
}

vscodium::uninstall () {
    echo "└> Uninstalling vscodium configuration."

    rm "$XDG_DATA_HOME/applications/vscodium-wayland.desktop"
    rm "$XDG_DATA_HOME/applications/vscodium.desktop"
}
