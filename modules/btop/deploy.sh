#-------------------------------------------------------------------------------
# Deploy btop configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/modules/lib-shell-utils/src/fs.sh"


btop::install () {
    echo "└> Installing btop configuration."

    local src="$base_dir/modules/btop/src"

    ensure_directory "$XDG_CONFIG_HOME/btop"
    force_link "$src/btop.conf" "$XDG_CONFIG_HOME/btop/btop.conf"

    ensure_directory "$XDG_CONFIG_HOME/btop/themes"
    # TODO: Extract templating to a shared function.
    esh "$src/themes/carbon.theme~esh" > "$XDG_CONFIG_HOME/btop/themes/carbon.theme"
}

btop::uninstall () {
    echo "└> Uninstalling btop configuration."

    rm -r "$XDG_CONFIG_HOME/btop"
}
