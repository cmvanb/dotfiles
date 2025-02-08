#-------------------------------------------------------------------------------
# Deploy vscodium configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"
source "$base_dir/config/lib-shell-utils/template.sh"


vscodium::install () {
    echo "└> Installing vscodium configuration."

    ensure_directory "$XDG_DATA_HOME/vscode/user-data/User"
    force_link "$base_dir/config/vscodium/keybindings.json" "$XDG_DATA_HOME/vscode/user-data/User/keybindings.json"
    force_link "$base_dir/config/vscodium/settings.json" "$XDG_DATA_HOME/vscode/user-data/User/settings.json"

    ensure_directory "$XDG_DATA_HOME/vscode/extensions/custom-theme/themes"
    render_esh_template "$base_dir/config/vscodium/theme.json~esh" "$base_dir/config/vscodium/custom-theme/themes/theme.json"
    force_link "$base_dir/config/vscodium/custom-theme" "$XDG_DATA_HOME/vscode/extensions/custom-theme"

    ensure_directory "$XDG_DATA_HOME/applications"
    force_link "$base_dir/config/vscodium/vscodium-wayland.desktop" "$XDG_DATA_HOME/applications/vscodium-wayland.desktop"
    force_link "$base_dir/config/vscodium/vscodium.desktop" "$XDG_DATA_HOME/applications/vscodium.desktop"
}

vscodium::uninstall () {
    echo "└> Uninstalling vscodium configuration."

    rm "$XDG_DATA_HOME/applications/vscodium-wayland.desktop"
    rm "$XDG_DATA_HOME/applications/vscodium.desktop"
}
