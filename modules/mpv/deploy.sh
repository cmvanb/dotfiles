#-------------------------------------------------------------------------------
# Deploy mpv configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/modules/lib-shell-utils/src/fs.sh"


mpv::install () {
    echo "└> Installing mpv configuration."

    local src="$base_dir/modules/mpv/src"

    force_link "$src" "$XDG_CONFIG_HOME/mpv"
}

mpv::uninstall () {
    echo "└> Uninstalling mpv configuration."

    rm "$XDG_CONFIG_HOME/mpv"
}
