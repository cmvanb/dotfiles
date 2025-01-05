#-------------------------------------------------------------------------------
# Deploy draw.io configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
data_dir=${XDG_DATA_HOME:-$HOME/.local/share}

source "$base_dir/local/opt/shell-utils/fs.sh"


draw.io::install () {
    echo "└> Installing draw.io configuration."

    mkdir -p "$data_dir/applications"
    esh "$base_dir/local/share/applications/draw.io.desktop~esh" > "$data_dir/applications/draw.io.desktop"
}

draw.io::uninstall () {
    echo "└> Uninstalling draw.io configuration."

    rm "$data_dir/applications/draw.io.desktop"
}
