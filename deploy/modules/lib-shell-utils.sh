#-------------------------------------------------------------------------------
# Deploy shell utility libraries
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
opt_dir=${XDG_OPT_HOME:-$HOME/.local/opt}

source "$base_dir/local/opt/shell-utils/fs.sh"


lib-shell-utils::install () {
    echo "└> Installing shell utility libraries."

    mkdir -p "$opt_dir"
    force_link "$base_dir/local/opt/shell-utils" "$opt_dir/shell-utils"
}

lib-shell-utils::uninstall () {
    echo "└> Uninstalling shell utility libraries."

    rm -rf "$opt_dir/shell-utils"
}
