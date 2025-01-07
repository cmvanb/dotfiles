#-------------------------------------------------------------------------------
# Deploy npm configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


npm::install () {
    echo "└> Installing npm configuration."

    force_link "$base_dir/config/npm" "$XDG_CONFIG_HOME/npm"
}

npm::uninstall () {
    echo "└> Uninstalling npm configuration."

    rm "$XDG_CONFIG_HOME/npm"
}
