#-------------------------------------------------------------------------------
# Deploy wofi configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/local/opt/shell-utils/fs.sh"


wofi::install () {
    echo "└> Installing wofi configuration."

    mkdir -p "$XDG_CONFIG_HOME/wofi"
    force_link "$base_dir/config/wofi/config" "$XDG_CONFIG_HOME/wofi/config"
    esh "$base_dir/config/wofi/style.css~esh" > "$XDG_CONFIG_HOME/wofi/style.css"
}

wofi::uninstall () {
    echo "└> Uninstalling wofi configuration."

    rm -r "$XDG_CONFIG_HOME/wofi"
}
