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

    fs::force_link "$src/bash/python.sh"   "$XDG_CONFIG_HOME/bash/conf.d/python.sh"
    fs::force_link "$src/fish/python.fish" "$XDG_CONFIG_HOME/fish/conf.d/python.fish"
}

python::uninstall () {
    echo "└> Uninstalling python configuration."

    fs::remove "$XDG_CONFIG_HOME/pip/pip.conf"

    fs::remove "$XDG_SCRIPTS_HOME/generate-venv.sh"

    fs::remove "$XDG_CONFIG_HOME/bash/conf.d/python.sh"
    fs::remove "$XDG_CONFIG_HOME/fish/conf.d/python.fish"
}
