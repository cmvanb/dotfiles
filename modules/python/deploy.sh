#-------------------------------------------------------------------------------
# Deploy python configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


python::install () {
    echo "└> Installing python configuration."

    local src="$base_dir/modules/python/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/pip"
    fs::force_link "$src/pip.conf" "$XDG_CONFIG_HOME/pip/pip.conf"

    fs::ensure_directory "$XDG_SCRIPTS_HOME"
    fs::force_link "$src/generate-venv.sh" "$XDG_SCRIPTS_HOME/generate-venv.sh"
}

python::uninstall () {
    echo "└> Uninstalling python configuration."

    rm -f "$XDG_CONFIG_HOME/pip/pip.conf"
    rmdir --ignore-fail-on-non-empty "$XDG_CONFIG_HOME/pip"

    rm -f "$XDG_SCRIPTS_HOME/generate-venv.sh"
}
