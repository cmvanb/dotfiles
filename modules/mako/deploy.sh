#-------------------------------------------------------------------------------
# Deploy mako configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


mako::install () {
    echo "└> Installing mako configuration."

    local src="$base_dir/modules/mako/src"

    ensure_directory "$XDG_CONFIG_HOME/mako"
    render_esh_template "$src/config~esh" "$XDG_CONFIG_HOME/mako/config"
}

mako::uninstall () {
    echo "└> Uninstalling mako configuration."

    rm -r "$XDG_CONFIG_HOME/mako"
}
