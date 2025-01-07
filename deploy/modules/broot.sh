#-------------------------------------------------------------------------------
# Deploy broot configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


broot::install () {
    echo "└> Installing broot configuration."

    ensure_directory "$XDG_CONFIG_HOME/broot"
    force_link "$base_dir/config/broot/brcd.sh" "$XDG_CONFIG_HOME/broot/brcd.sh"
    force_link "$base_dir/config/broot/brcd.fish" "$XDG_CONFIG_HOME/broot/brcd.fish"
    force_link "$base_dir/config/broot/conf.hjson" "$XDG_CONFIG_HOME/broot/conf.hjson"
    force_link "$base_dir/config/broot/verbs.hjson" "$XDG_CONFIG_HOME/broot/verbs.hjson"

    ensure_directory "$XDG_CONFIG_HOME/broot/skins"
    esh "$base_dir/config/broot/skins/carbon-dark.hjson~esh" > "$XDG_CONFIG_HOME/broot/skins/carbon-dark.hjson"
}

broot::uninstall () {
    echo "└> Uninstalling broot configuration."

    rm -r "$XDG_CONFIG_HOME/broot"
}
