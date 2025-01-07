#-------------------------------------------------------------------------------
# Deploy lf configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/local/opt/shell-utils/fs.sh"


lf::install () {
    echo "└> Installing lf configuration."

    force_link "$base_dir/config/lf" "$XDG_CONFIG_HOME/lf"

    mkdir -p "$XDG_DATA_HOME/applications"
    force_link "$base_dir/local/share/applications/lf.desktop" "$XDG_DATA_HOME/applications/lf.desktop"
}

lf::uninstall () {
    echo "└> Uninstalling lf configuration."

    rm "$XDG_CONFIG_HOME/lf"

    rm "$XDG_DATA_HOME/applications/lf.desktop"
}
