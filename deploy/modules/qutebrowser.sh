#-------------------------------------------------------------------------------
# Deploy qutebrowser configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
data_dir=${XDG_DATA_HOME:-$HOME/.local/share}

source "$base_dir/local/opt/shell-utils/fs.sh"


qutebrowser::install () {
    echo "└> Installing qutebrowser configuration."

    mkdir -p "$config_dir/qutebrowser"
    force_link "$base_dir/config/qutebrowser/config.py" "$config_dir/qutebrowser/config.py"
    force_link "$base_dir/config/qutebrowser/stylesheet.css" "$config_dir/qutebrowser/stylesheet.css"

    mkdir -p "$data_dir/applications"
    force_link "$base_dir/local/share/applications/org.qutebrowser.qutebrowser.desktop" "$data_dir/applications/org.qutebrowser.qutebrowser.desktop"

    mkdir -p "$data_dir/qutebrowser/userscripts"
    force_link "$base_dir/local/share/qutebrowser/userscripts/format_json.sh" "$data_dir/qutebrowser/userscripts/format_json.sh"
    force_link "$base_dir/local/share/qutebrowser/userscripts/readability.py" "$data_dir/qutebrowser/userscripts/readability.py"
}

qutebrowser::uninstall () {
    echo "└> Uninstalling qutebrowser configuration."

    rm -r "$config_dir/qutebrowser"

    rm "$data_dir/applications/org.qutebrowser.qutebrowser.desktop"
}
