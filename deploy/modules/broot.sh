#-------------------------------------------------------------------------------
# Deploy broot configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


broot::install () {
    echo "└> Installing broot configuration."

    mkdir -p "$config_dir/broot"
    force_link "$base_dir/config/broot/brcd.sh" "$config_dir/broot/brcd.sh"
    force_link "$base_dir/config/broot/brcd.fish" "$config_dir/broot/brcd.fish"
    force_link "$base_dir/config/broot/conf.hjson" "$config_dir/broot/conf.hjson"
    force_link "$base_dir/config/broot/verbs.hjson" "$config_dir/broot/verbs.hjson"

    mkdir -p "$config_dir/broot/skins"
    esh "$base_dir/config/broot/skins/carbon-dark.hjson~esh" > "$config_dir/broot/skins/carbon-dark.hjson"
}

broot::uninstall () {
    echo "└> Uninstalling broot configuration."

    rm -r "$config_dir/broot"
}
