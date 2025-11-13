#-------------------------------------------------------------------------------
# Deploy gitui configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


gitui::install () {
    echo "└> Installing gitui configuration."

    force_link "$base_dir/config/gitui" "$XDG_CONFIG_HOME/gitui"
}

gitui::uninstall () {
    echo "└> Uninstalling gitui configuration."

    rm "$XDG_CONFIG_HOME/gitui"
}
