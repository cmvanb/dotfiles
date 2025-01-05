#-------------------------------------------------------------------------------
# Deploy ghostty configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


ghostty::install () {
    echo "└> Installing ghostty configuration."

    mkdir -p "$config_dir/ghostty"
    force_link "$base_dir/config/ghostty/config" "$config_dir/ghostty/config"
}

ghostty::uninstall () {
    echo "└> Uninstalling ghostty configuration."

    rm -r "$config_dir/ghostty"
}
