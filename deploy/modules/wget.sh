#-------------------------------------------------------------------------------
# Deploy wget configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


wget::install () {
    echo "└> Installing wget configuration."

    mkdir -p "$config_dir/wget"
    esh "$base_dir/config/wget/wgetrc~esh" > "$config_dir/wget/wgetrc"
}

wget::uninstall () {
    echo "└> Uninstalling wget configuration."

    rm -r "$config_dir/wget"
}
