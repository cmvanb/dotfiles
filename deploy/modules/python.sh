#-------------------------------------------------------------------------------
# Deploy python configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/local/opt/shell-utils/fs.sh"


python::install () {
    echo "└> Installing python configuration."

    force_link "$base_dir/config/pip" "$XDG_CONFIG_HOME/pip"

    force_link "$base_dir/local/scripts/generate-venv.sh" "$XDG_SCRIPTS_HOME/generate-venv.sh"
}

python::uninstall () {
    echo "└> Uninstalling python configuration."

    rm "$XDG_CONFIG_HOME/pip"
}
