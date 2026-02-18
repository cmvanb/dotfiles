#-------------------------------------------------------------------------------
# Deploy direnv configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


direnv::install () {
    echo "└> Installing direnv configuration."

    local src="$base_dir/modules/direnv/src"

    force_link "$src" "$XDG_CONFIG_HOME/direnv"
}

direnv::uninstall () {
    echo "└> Uninstalling direnv configuration."

    rm -r "$XDG_CONFIG_HOME/direnv"
}
