#-------------------------------------------------------------------------------
# Deploy git configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/local/opt/shell-utils/fs.sh"


git::install () {
    echo "└> Installing git configuration."

    force_link "$base_dir/config/git" "$XDG_CONFIG_HOME/git"
}

git::uninstall () {
    echo "└> Uninstalling git configuration."

    rm "$XDG_CONFIG_HOME/git"
}
