#-------------------------------------------------------------------------------
# Deploy git configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


git::install () {
    echo "└> Installing git configuration."

    force_link "$base_dir/config/git" "$config_dir/git"
}

git::uninstall () {
    echo "└> Uninstalling git configuration."

    rm "$config_dir/git"
}
