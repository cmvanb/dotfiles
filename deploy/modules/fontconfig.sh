#-------------------------------------------------------------------------------
# Deploy fontconfig configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/local/opt/shell-utils/fs.sh"


fontconfig::install () {
    echo "└> Installing fontconfig configuration."

    mkdir -p "$XDG_CONFIG_HOME/fontconfig"
    esh "$base_dir/config/fontconfig/fonts.conf~esh" > "$XDG_CONFIG_HOME/fontconfig/fonts.conf"
}

fontconfig::uninstall () {
    echo "└> Uninstalling fontconfig configuration."

    rm -r "$XDG_CONFIG_HOME/fontconfig"
}
