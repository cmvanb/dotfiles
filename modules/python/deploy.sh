#-------------------------------------------------------------------------------
# Deploy python configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/modules/lib-shell-utils/src/fs.sh"


python::install () {
    echo "└> Installing python configuration."

    local src="$base_dir/modules/python/src"

    force_link "$base_dir/modules/pip/src" "$XDG_CONFIG_HOME/pip"

    force_link "$src/generate-venv.sh" "$XDG_SCRIPTS_HOME/generate-venv.sh"
}

python::uninstall () {
    echo "└> Uninstalling python configuration."

    rm "$XDG_CONFIG_HOME/pip"
}
