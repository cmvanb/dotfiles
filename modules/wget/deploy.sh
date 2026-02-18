#-------------------------------------------------------------------------------
# Deploy wget configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


wget::install () {
    echo "└> Installing wget configuration."

    local src="$base_dir/modules/wget/src"

    ensure_directory "$XDG_CONFIG_HOME/wget"
    esh "$src/wgetrc~esh" > "$XDG_CONFIG_HOME/wget/wgetrc"
}

wget::uninstall () {
    echo "└> Uninstalling wget configuration."

    rm -r "$XDG_CONFIG_HOME/wget"
}
