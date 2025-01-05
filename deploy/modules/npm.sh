#-------------------------------------------------------------------------------
# Deploy npm configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


npm::install () {
    echo "└> Installing npm configuration."

    force_link "$base_dir/config/npm" "$config_dir/npm"
}

npm::uninstall () {
    echo "└> Uninstalling npm configuration."

    rm "$config_dir/npm"
}
