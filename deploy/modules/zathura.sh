#-------------------------------------------------------------------------------
# Deploy zathura configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


zathura::install () {
    echo "└> Installing zathura configuration."

    mkdir -p "$XDG_CONFIG_HOME/zathura"
    esh "$base_dir/config/zathura/zathurarc~esh" > "$XDG_CONFIG_HOME/zathura/zathurarc"

    mkdir -p "$XDG_DATA_HOME/applications"
    force_link "$base_dir/config/zathura/org.pwmt.zathura.desktop" "$XDG_DATA_HOME/applications/org.pwmt.zathura.desktop"
}

zathura::uninstall () {
    echo "└> Uninstalling zathura configuration."

    rm -r "$XDG_CONFIG_HOME/zathura"

    rm "$XDG_DATA_HOME/applications/org.pwmt.zathura.desktop"
}
