#-------------------------------------------------------------------------------
# Deploy gimp configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


gimp::install () {
    echo "└> Installing gimp configuration."

    local src="$base_dir/modules/gimp/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/GIMP/3.0"
    fs::force_link "$src/gimprc" "$XDG_CONFIG_HOME/GIMP/3.0/gimprc"
}

gimp::uninstall () {
    echo "└> Uninstalling gimp configuration."

    rm "$XDG_CONFIG_HOME/GIMP/3.0/gimprc"
}
