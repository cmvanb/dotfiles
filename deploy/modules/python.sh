#-------------------------------------------------------------------------------
# Deploy python configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
scripts_dir=${XDG_SCRIPTS_HOME:-$HOME/.local/scripts}

source "$base_dir/local/opt/shell-utils/fs.sh"


python::install () {
    echo "└> Installing python configuration."

    force_link "$base_dir/config/pip" "$config_dir/pip"

    force_link "$base_dir/local/scripts/generate-venv.sh" "$scripts_dir/generate-venv.sh"
}

python::uninstall () {
    echo "└> Uninstalling python configuration."

    rm "$config_dir/pip"
}
