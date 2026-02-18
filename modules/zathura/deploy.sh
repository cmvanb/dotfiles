#-------------------------------------------------------------------------------
# Deploy zathura configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


zathura::install () {
    echo "└> Installing zathura configuration."

    local src="$base_dir/modules/zathura/src"

    ensure_directory "$XDG_CONFIG_HOME/zathura"
    esh "$src/zathurarc~esh" > "$XDG_CONFIG_HOME/zathura/zathurarc"

    ensure_directory "$XDG_DATA_HOME/applications"
    force_link "$src/org.pwmt.zathura.desktop" "$XDG_DATA_HOME/applications/org.pwmt.zathura.desktop"
}

zathura::uninstall () {
    echo "└> Uninstalling zathura configuration."

    rm -r "$XDG_CONFIG_HOME/zathura"

    rm "$XDG_DATA_HOME/applications/org.pwmt.zathura.desktop"
}
