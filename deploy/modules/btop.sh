#-------------------------------------------------------------------------------
# Deploy btop configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


btop::install () {
    echo "└> Installing btop configuration."

    ensure_directory "$XDG_CONFIG_HOME/btop"
    force_link "$base_dir/config/btop/btop.conf" "$XDG_CONFIG_HOME/btop/btop.conf"

    ensure_directory "$XDG_CONFIG_HOME/btop/themes"
    # TODO: Extract templating to a shared function.
    esh "$base_dir/config/btop/themes/carbon.theme~esh" > "$XDG_CONFIG_HOME/btop/themes/carbon.theme"
}

btop::uninstall () {
    echo "└> Uninstalling btop configuration."

    rm -r "$XDG_CONFIG_HOME/btop"
}
