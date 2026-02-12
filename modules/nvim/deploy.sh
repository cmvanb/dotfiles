#-------------------------------------------------------------------------------
# Deploy nvim configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/modules/lib-shell-utils/src/fs.sh"


nvim::install () {
    echo "└> Installing nvim configuration."

    local src="$base_dir/modules/nvim/src"

    git submodule update --recursive --remote

    force_link "$src" "$XDG_CONFIG_HOME/nvim"
}

nvim::uninstall () {
    echo "└> Uninstalling nvim configuration."

    rm "$XDG_CONFIG_HOME/nvim"
}
