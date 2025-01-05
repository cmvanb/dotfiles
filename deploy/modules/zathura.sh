#-------------------------------------------------------------------------------
# Deploy zathura configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
data_dir=${XDG_DATA_HOME:-$HOME/.local/share}

source "$base_dir/local/opt/shell-utils/fs.sh"


zathura::install () {
    echo "└> Installing zathura configuration."

    mkdir -p "$config_dir/zathura"
    esh "$base_dir/config/zathura/zathurarc~esh" > "$config_dir/zathura/zathurarc"

    mkdir -p "$data_dir/applications"
    force_link "$base_dir/local/share/applications/org.pwmt.zathura.desktop" "$data_dir/applications/org.pwmt.zathura.desktop"
}

zathura::uninstall () {
    echo "└> Uninstalling zathura configuration."

    rm -r "$config_dir/zathura"

    rm "$data_dir/applications/org.pwmt.zathura.desktop"
}
