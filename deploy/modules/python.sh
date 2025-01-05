#-------------------------------------------------------------------------------
# Deploy python configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


python::install () {
    echo "└> Installing python configuration."

    force_link "$base_dir/config/pip" "$config_dir/pip"
}

python::uninstall () {
    echo "└> Uninstalling python configuration."

    rm "$config_dir/pip"
}
