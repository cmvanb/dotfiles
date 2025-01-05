#-------------------------------------------------------------------------------
# Deploy mpv configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


mpv::install () {
    echo "└> Installing mpv configuration."

    force_link "$base_dir/config/mpv" "$config_dir/mpv"
}

mpv::uninstall () {
    echo "└> Uninstalling mpv configuration."

    rm "$config_dir/mpv"
}
