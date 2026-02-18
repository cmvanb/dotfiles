#-------------------------------------------------------------------------------
# Deploy git configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


git::install () {
    echo "└> Installing git configuration."

    local src="$base_dir/modules/git/src"

    force_link "$src" "$XDG_CONFIG_HOME/git"
}

git::uninstall () {
    echo "└> Uninstalling git configuration."

    rm "$XDG_CONFIG_HOME/git"
}
