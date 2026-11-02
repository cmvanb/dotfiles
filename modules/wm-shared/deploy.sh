#-------------------------------------------------------------------------------
# Deploy window manager agnostic configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
host=$(uname -n)

source "$base_dir/lib/fs.sh"


wm-shared::install () {
    echo "└> Installing shared window manager configuration."

    local src="$base_dir/modules/wm-shared/src"

    fs::force_link "$src/wsesh" "$XDG_CONFIG_HOME/wsesh"

    if [[ $host == "casino" ]]; then
        fs::ensure_directory "$XDG_CONFIG_HOME/wm"
        fs::force_link "$src/outputs/output-order.casino" "$XDG_CONFIG_HOME/wm/output-order"

    elif [[ $host == "cyxwel" ]]; then
        fs::ensure_directory "$XDG_CONFIG_HOME/wm"
        fs::force_link "$src/outputs/output-order.cyxwel" "$XDG_CONFIG_HOME/wm/output-order"

    else
        echo "└> Warning: No output order for host '$host'."
    fi
}

wm-shared::uninstall () {
    echo "└> Uninstalling shared window manager configuration."

    fs::remove "$XDG_CONFIG_HOME/wsesh"
    fs::remove "$XDG_CONFIG_HOME/wm"
}
