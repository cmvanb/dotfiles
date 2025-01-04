#-------------------------------------------------------------------------------
# Deploy virtual terminal configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


vt::install () {
    echo "└> Installing virtual terminal configuration."

    force_link "$base_dir/config/vt" "$config_dir/vt"
}

vt::uninstall () {
    echo "└> Uninstalling virtual terminal configuration."

    rm "$config_dir/vt"
}
