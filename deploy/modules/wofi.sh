#-------------------------------------------------------------------------------
# Deploy wofi configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


wofi::install () {
    echo "└> Installing wofi configuration."

    mkdir -p "$config_dir/wofi"
    force_link "$base_dir/config/wofi/config" "$config_dir/wofi/config"
    esh "$base_dir/config/wofi/style.css~esh" > "$config_dir/wofi/style.css"
}

wofi::uninstall () {
    echo "└> Uninstalling wofi configuration."

    rm -r "$config_dir/wofi"
}
