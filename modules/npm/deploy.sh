#-------------------------------------------------------------------------------
# Deploy npm configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/modules/lib-shell-utils/src/fs.sh"


npm::install () {
    echo "└> Installing npm configuration."

    local src="$base_dir/modules/npm/src"

    force_link "$src" "$XDG_CONFIG_HOME/npm"
}

npm::uninstall () {
    echo "└> Uninstalling npm configuration."

    rm "$XDG_CONFIG_HOME/npm"
}
