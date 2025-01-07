#-------------------------------------------------------------------------------
# Deploy mpv configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


mpv::install () {
    echo "└> Installing mpv configuration."

    force_link "$base_dir/config/mpv" "$XDG_CONFIG_HOME/mpv"
}

mpv::uninstall () {
    echo "└> Uninstalling mpv configuration."

    rm "$XDG_CONFIG_HOME/mpv"
}
