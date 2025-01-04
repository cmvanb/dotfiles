#-------------------------------------------------------------------------------
# Deploy mako configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


mako::install () {
    echo "└> Installing mako configuration."

    mkdir -p "$config_dir/mako"
    esh "$base_dir/config/mako/config~esh" > "$config_dir/mako/config"
}

mako::uninstall () {
    echo "└> Uninstalling mako configuration."

    rm -r "$config_dir/mako"
}
