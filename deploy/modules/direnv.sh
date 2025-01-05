#-------------------------------------------------------------------------------
# Deploy direnv configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


direnv::install () {
    echo "└> Installing direnv configuration."

    force_link "$base_dir/config/direnv" "$config_dir/direnv"
}

direnv::uninstall () {
    echo "└> Uninstalling direnv configuration."

    rm -r "$config_dir/direnv"
}
