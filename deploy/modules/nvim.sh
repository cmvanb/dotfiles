#-------------------------------------------------------------------------------
# Deploy nvim configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


nvim::install () {
    echo "└> Installing nvim configuration."

    force_link "$base_dir/config/nvim" "$XDG_CONFIG_HOME/nvim"
}

nvim::uninstall () {
    echo "└> Uninstalling nvim configuration."

    rm "$XDG_CONFIG_HOME/nvim"
}
