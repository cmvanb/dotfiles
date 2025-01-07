#-------------------------------------------------------------------------------
# Deploy virtual terminal configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/local/opt/shell-utils/fs.sh"


vt::install () {
    echo "└> Installing virtual terminal configuration."

    force_link "$base_dir/config/vt" "$XDG_CONFIG_HOME/vt"
}

vt::uninstall () {
    echo "└> Uninstalling virtual terminal configuration."

    rm "$XDG_CONFIG_HOME/vt"
}
