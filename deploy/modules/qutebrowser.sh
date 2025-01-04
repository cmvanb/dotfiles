#-------------------------------------------------------------------------------
# Deploy qutebrowser configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


qutebrowser::install () {
    echo "└> Installing qutebrowser configuration."

    mkdir -p "$config_dir/qutebrowser"
    force_link "$base_dir/config/qutebrowser/config.py" "$config_dir/qutebrowser/config.py"
    force_link "$base_dir/config/qutebrowser/stylesheet.css" "$config_dir/qutebrowser/stylesheet.css"
}

qutebrowser::uninstall () {
    echo "└> Uninstalling qutebrowser configuration."

    rm -r "$config_dir/qutebrowser"
}
