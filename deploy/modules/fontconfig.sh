#-------------------------------------------------------------------------------
# Deploy fontconfig configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


fontconfig::install () {
    echo "└> Installing fontconfig configuration."

    mkdir -p "$config_dir/fontconfig"
    esh "$base_dir/config/fontconfig/fonts.conf~esh" > "$config_dir/fontconfig/fonts.conf"
}

fontconfig::uninstall () {
    echo "└> Uninstalling fontconfig configuration."

    rm -r "$config_dir/fontconfig"
}
