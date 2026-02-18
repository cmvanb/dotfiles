#-------------------------------------------------------------------------------
# Deploy broot configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


broot::install () {
    echo "└> Installing broot configuration."

    local src="$base_dir/modules/broot/src"

    ensure_directory "$XDG_CONFIG_HOME/broot"
    force_link "$src/brcd.sh" "$XDG_CONFIG_HOME/broot/brcd.sh"
    force_link "$src/brcd.fish" "$XDG_CONFIG_HOME/broot/brcd.fish"
    force_link "$src/conf.hjson" "$XDG_CONFIG_HOME/broot/conf.hjson"
    force_link "$src/verbs.hjson" "$XDG_CONFIG_HOME/broot/verbs.hjson"

    ensure_directory "$XDG_CONFIG_HOME/broot/skins"
    esh "$src/skins/carbon-dark.hjson~esh" > "$XDG_CONFIG_HOME/broot/skins/carbon-dark.hjson"
}

broot::uninstall () {
    echo "└> Uninstalling broot configuration."

    rm -r "$XDG_CONFIG_HOME/broot"
}
