#-------------------------------------------------------------------------------
# Deploy btop configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


btop::install () {
    echo "└> Installing btop configuration."

    mkdir -p "$config_dir/btop"
    force_link "$base_dir/config/btop/btop.conf" "$config_dir/btop/btop.conf"

    mkdir -p "$config_dir/btop/themes"
    # TODO: Extract templating to a shared function.
    esh "$base_dir/config/btop/themes/carbon.theme~esh" > "$config_dir/btop/themes/carbon.theme"
}

btop::uninstall () {
    echo "└> Uninstalling btop configuration."
}
