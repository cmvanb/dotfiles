#-------------------------------------------------------------------------------
# Deploy direnv configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


direnv::install () {
    echo "└> Installing direnv configuration."

    force_link "$base_dir/config/direnv" "$XDG_CONFIG_HOME/direnv"
}

direnv::uninstall () {
    echo "└> Uninstalling direnv configuration."

    rm -r "$XDG_CONFIG_HOME/direnv"
}
