#-------------------------------------------------------------------------------
# Deploy virtual terminal configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/modules/lib-shell-utils/src/fs.sh"


vt::install () {
    echo "└> Installing virtual terminal configuration."

    local src="$base_dir/modules/vt/src"

    force_link "$src" "$XDG_CONFIG_HOME/vt"
}

vt::uninstall () {
    echo "└> Uninstalling virtual terminal configuration."

    rm "$XDG_CONFIG_HOME/vt"
}
