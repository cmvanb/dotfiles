#-------------------------------------------------------------------------------
# Deploy draw.io configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/modules/lib-shell-utils/src/fs.sh"


draw.io::install () {
    echo "└> Installing draw.io configuration."

    local src="$base_dir/modules/draw.io/src"

    ensure_directory "$XDG_DATA_HOME/applications"
    esh "$src/draw.io.desktop~esh" > "$XDG_DATA_HOME/applications/draw.io.desktop"
}

draw.io::uninstall () {
    echo "└> Uninstalling draw.io configuration."

    rm "$XDG_DATA_HOME/applications/draw.io.desktop"
}
