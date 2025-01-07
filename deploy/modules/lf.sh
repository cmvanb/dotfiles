#-------------------------------------------------------------------------------
# Deploy lf configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


lf::install () {
    echo "└> Installing lf configuration."

    ensure_directory "$XDG_CONFIG_HOME/lf"
    force_link "$base_dir/config/lf/icons" "$XDG_CONFIG_HOME/lf/icons"
    force_link "$base_dir/config/lf/lf-open.sh" "$XDG_CONFIG_HOME/lf/lf-open.sh"
    force_link "$base_dir/config/lf/lfcd.fish" "$XDG_CONFIG_HOME/lf/lfcd.fish"
    force_link "$base_dir/config/lf/lfcd.sh" "$XDG_CONFIG_HOME/lf/lfcd.sh"
    force_link "$base_dir/config/lf/lfrc" "$XDG_CONFIG_HOME/lf/lfrc"

    ensure_directory "$XDG_DATA_HOME/applications"
    force_link "$base_dir/config/lf/lf.desktop" "$XDG_DATA_HOME/applications/lf.desktop"
}

lf::uninstall () {
    echo "└> Uninstalling lf configuration."

    rm -r "$XDG_CONFIG_HOME/lf"

    rm "$XDG_DATA_HOME/applications/lf.desktop"
}
