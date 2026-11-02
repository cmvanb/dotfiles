#-------------------------------------------------------------------------------
# Deploy gitui configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


gitui::install () {
    echo "└> Installing gitui configuration."

    local src="$base_dir/extras/gitui/src"

    fs::force_link "$src" "$XDG_CONFIG_HOME/gitui"
}

gitui::uninstall () {
    echo "└> Uninstalling gitui configuration."

    fs::remove "$XDG_CONFIG_HOME/gitui"
}
