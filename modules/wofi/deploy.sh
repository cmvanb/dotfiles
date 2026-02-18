#-------------------------------------------------------------------------------
# Deploy wofi configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


wofi::install () {
    echo "└> Installing wofi configuration."

    local src="$base_dir/modules/wofi/src"

    ensure_directory "$XDG_CONFIG_HOME/wofi"
    force_link "$src/config" "$XDG_CONFIG_HOME/wofi/config"
    render_esh_template "$src/style.css~esh" "$XDG_CONFIG_HOME/wofi/style.css"
}

wofi::uninstall () {
    echo "└> Uninstalling wofi configuration."

    rm -r "$XDG_CONFIG_HOME/wofi"
}
