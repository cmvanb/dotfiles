#-------------------------------------------------------------------------------
# Deploy git configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


git::install () {
    echo "└> Installing git configuration."

    local src="$base_dir/modules/git/src"

    ensure_directory "$XDG_CONFIG_HOME/git"

    template::render_mako "$src/config.mako"  "$XDG_CONFIG_HOME/git/config"
    force_link  "$src/ignore"       "$XDG_CONFIG_HOME/git/ignore"
}

git::uninstall () {
    echo "└> Uninstalling git configuration."

    rm "$XDG_CONFIG_HOME/git/config"
    rm "$XDG_CONFIG_HOME/git/ignore"
}
