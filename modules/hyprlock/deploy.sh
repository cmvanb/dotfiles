#-------------------------------------------------------------------------------
# Deploy hyprlock configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/modules/lib-shell-utils/src/fs.sh"
source "$base_dir/modules/lib-shell-utils/src/template.sh"


hyprlock::install () {
    echo "└> Installing hyprlock configuration."

    local src="$base_dir/modules/hyprlock/src"

    ensure_directory "$XDG_CONFIG_HOME/hypr"

    # Configuration files.
    render_esh_template \
        "$src/hyprlock.conf~esh" \
        "$XDG_CONFIG_HOME/hypr/hyprlock.conf"
}

hyprlock::uninstall () {
    echo "└> Uninstalling hyprlock configuration."

    rm -r "$XDG_CONFIG_HOME/hyprlock"
}
