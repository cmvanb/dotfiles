#-------------------------------------------------------------------------------
# Deploy mako configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


mako::install () {
    echo "└> Installing mako configuration."

    mkdir -p "$XDG_CONFIG_HOME/mako"
    esh "$base_dir/config/mako/config~esh" > "$XDG_CONFIG_HOME/mako/config"
}

mako::uninstall () {
    echo "└> Uninstalling mako configuration."

    rm -r "$XDG_CONFIG_HOME/mako"
}
