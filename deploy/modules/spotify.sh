#-------------------------------------------------------------------------------
# Deploy spotify configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


spotify::install () {
    echo "└> Installing spotify configuration."

    ensure_directory "$XDG_DATA_HOME/applications"
    force_link "$base_dir/config/spotify/spotify.desktop" "$XDG_DATA_HOME/applications/spotify.desktop"
}

spotify::uninstall () {
    echo "└> Uninstalling spotify configuration."

    rm "$XDG_DATA_HOME/applications/spotify.desktop"
}
