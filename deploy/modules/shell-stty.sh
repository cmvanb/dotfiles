#-------------------------------------------------------------------------------
# Deploy shell-stty configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


shell-stty::install () {
    echo "└> Installing shell-stty configuration."

    # TODO: Rename.
    force_link "$base_dir/config/shell" "$config_dir/shell"
}

shell-stty::uninstall () {
    echo "└> Uninstalling shell-stty configuration."

    rm "$config_dir/shell"
}
