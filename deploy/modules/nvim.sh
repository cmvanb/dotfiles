#-------------------------------------------------------------------------------
# Deploy nvim configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


nvim::install () {
    echo "└> Installing nvim configuration."

    force_link "$base_dir/config/nvim" "$config_dir/nvim"
}

nvim::uninstall () {
    echo "└> Uninstalling nvim configuration."

    rm "$config_dir/nvim"
}
