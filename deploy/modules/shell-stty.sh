#-------------------------------------------------------------------------------
# Deploy shell-stty configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


shell-stty::install () {
    echo "└> Installing shell stty configuration."

    force_link "$base_dir/config/shell-stty" "$XDG_CONFIG_HOME/shell-stty"
}

shell-stty::uninstall () {
    echo "└> Uninstalling shell stty configuration."

    rm "$XDG_CONFIG_HOME/shell-stty"
}
