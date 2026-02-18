#-------------------------------------------------------------------------------
# Deploy lf configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


lf::install () {
    echo "└> Installing lf configuration."

    local src="$base_dir/modules/lf/src"

    ensure_directory "$XDG_CONFIG_HOME/lf"
    force_link "$src/icons" "$XDG_CONFIG_HOME/lf/icons"
    force_link "$src/lf-open.sh" "$XDG_CONFIG_HOME/lf/lf-open.sh"
    force_link "$src/lfcd.fish" "$XDG_CONFIG_HOME/lf/lfcd.fish"
    force_link "$src/lfcd.sh" "$XDG_CONFIG_HOME/lf/lfcd.sh"
    force_link "$src/lfrc" "$XDG_CONFIG_HOME/lf/lfrc"

    ensure_directory "$XDG_DATA_HOME/applications"
    force_link "$src/lf.desktop" "$XDG_DATA_HOME/applications/lf.desktop"
}

lf::uninstall () {
    echo "└> Uninstalling lf configuration."

    rm -r "$XDG_CONFIG_HOME/lf"

    rm "$XDG_DATA_HOME/applications/lf.desktop"
}
