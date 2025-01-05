#-------------------------------------------------------------------------------
# Deploy spotify configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
data_dir=${XDG_DATA_HOME:-$HOME/.local/share}

source "$base_dir/local/opt/shell-utils/fs.sh"


spotify::install () {
    echo "└> Installing spotify configuration."

    mkdir -p "$data_dir/applications"
    force_link "$base_dir/local/share/applications/spotify.desktop" "$data_dir/applications/spotify.desktop"
}

spotify::uninstall () {
    echo "└> Uninstalling spotify configuration."

    rm "$data_dir/applications/spotify.desktop"
}
