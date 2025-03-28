#-------------------------------------------------------------------------------
# Deploy wget configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


wget::install () {
    echo "└> Installing wget configuration."

    ensure_directory "$XDG_CONFIG_HOME/wget"
    esh "$base_dir/config/wget/wgetrc~esh" > "$XDG_CONFIG_HOME/wget/wgetrc"
}

wget::uninstall () {
    echo "└> Uninstalling wget configuration."

    rm -r "$XDG_CONFIG_HOME/wget"
}
