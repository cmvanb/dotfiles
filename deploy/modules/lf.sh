#-------------------------------------------------------------------------------
# Deploy lf configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
data_dir=${XDG_DATA_HOME:-$HOME/.local/share}

source "$base_dir/local/opt/shell-utils/fs.sh"


lf::install () {
    echo "└> Installing lf configuration."

    force_link "$base_dir/config/lf" "$config_dir/lf"

    mkdir -p "$data_dir/applications"
    force_link "$base_dir/local/share/applications/lf.desktop" "$data_dir/applications/lf.desktop"
}

lf::uninstall () {
    echo "└> Uninstalling lf configuration."

    rm "$config_dir/lf"

    rm "$data_dir/applications/lf.desktop"
}
