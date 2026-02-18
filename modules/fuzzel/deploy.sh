#-------------------------------------------------------------------------------
# Deploy fuzzel configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


fuzzel::install () {
    echo "└> Installing fuzzel configuration."

    local src="$base_dir/modules/fuzzel/src"

    ensure_directory "$XDG_CONFIG_HOME/fuzzel"
    render_esh_template "$src/fuzzel.ini~esh" "$XDG_CONFIG_HOME/fuzzel/fuzzel.ini"
}

fuzzel::uninstall () {
    echo "└> Uninstalling fuzzel configuration."

    rm -r "$XDG_CONFIG_HOME/fuzzel"
}
