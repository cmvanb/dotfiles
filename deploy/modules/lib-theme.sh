#-------------------------------------------------------------------------------
# Deploy theme libraries
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
opt_dir=${XDG_OPT_HOME:-$HOME/.local/opt}

source "$base_dir/local/opt/shell-utils/fs.sh"


lib-theme::install () {
    echo "└> Installing theme libraries."

    mkdir -p "$opt_dir"
    force_link "$base_dir/local/opt/theme" "$opt_dir/theme"
}

lib-theme::uninstall () {
    echo "└> Uninstalling theme libraries."

    rm -rf "$opt_dir/theme"
}
