#-------------------------------------------------------------------------------
# Deploy zathura configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


zathura::install () {
    echo "└> Installing zathura configuration."

    mkdir -p "$config_dir/zathura"
    esh "$base_dir/config/zathura/zathurarc~esh" > "$config_dir/zathura/zathurarc"
}

zathura::uninstall () {
    echo "└> Uninstalling zathura configuration."

    rm -r "$config_dir/zathura"
}
