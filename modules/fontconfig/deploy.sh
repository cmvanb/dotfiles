#-------------------------------------------------------------------------------
# Deploy fontconfig configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/modules/lib-shell-utils/src/fs.sh"


fontconfig::install () {
    echo "└> Installing fontconfig configuration."

    local src="$base_dir/modules/fontconfig/src"

    ensure_directory "$XDG_CONFIG_HOME/fontconfig"
    esh "$src/fonts.conf~esh" > "$XDG_CONFIG_HOME/fontconfig/fonts.conf"
}

fontconfig::uninstall () {
    echo "└> Uninstalling fontconfig configuration."

    rm -r "$XDG_CONFIG_HOME/fontconfig"
}
