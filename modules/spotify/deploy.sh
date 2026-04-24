#-------------------------------------------------------------------------------
# Deploy spotify configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


spotify::install () {
    echo "└> Installing spotify configuration."

    local src="$base_dir/modules/spotify/src"

    fs::ensure_directory "$XDG_DATA_HOME/applications"
    fs::force_link "$src/spotify.desktop" "$XDG_DATA_HOME/applications/spotify.desktop"
}

spotify::uninstall () {
    echo "└> Uninstalling spotify configuration."

    rm "$XDG_DATA_HOME/applications/spotify.desktop"
}
