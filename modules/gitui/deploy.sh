#-------------------------------------------------------------------------------
# Deploy gitui configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/modules/lib-shell-utils/src/fs.sh"


gitui::install () {
    echo "└> Installing gitui configuration."

    local src="$base_dir/modules/gitui/src"

    force_link "$src" "$XDG_CONFIG_HOME/gitui"
}

gitui::uninstall () {
    echo "└> Uninstalling gitui configuration."

    rm "$XDG_CONFIG_HOME/gitui"
}
