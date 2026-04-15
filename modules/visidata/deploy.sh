#-------------------------------------------------------------------------------
# Deploy visidata configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/debug.sh"
source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


visidata::install () {
    debug::assert_dependency vd

    echo "└> Installing visidata configuration."

    local src="$base_dir/modules/visidata/src"

    ensure_directory "$XDG_CONFIG_HOME/visidata"
    template::render_mako "$src/config.mako.py" "$XDG_CONFIG_HOME/visidata/config.py"
}

visidata::uninstall () {
    echo "└> Uninstalling visidata configuration."

    rm -f "$XDG_CONFIG_HOME/visidata/config.py"
}
