#-------------------------------------------------------------------------------
# Deploy draw.io configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


draw.io::install () {
    echo "└> Installing draw.io configuration."

    mkdir -p "$XDG_DATA_HOME/applications"
    esh "$base_dir/local/share/applications/draw.io.desktop~esh" > "$XDG_DATA_HOME/applications/draw.io.desktop"
}

draw.io::uninstall () {
    echo "└> Uninstalling draw.io configuration."

    rm "$XDG_DATA_HOME/applications/draw.io.desktop"
}
