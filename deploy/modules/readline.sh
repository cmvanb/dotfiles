#-------------------------------------------------------------------------------
# Deploy readline configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


readline::install () {
    echo "└> Installing readline configuration."

    force_link "$base_dir/config/readline" "$config_dir/readline"
}

readline::uninstall () {
    echo "└> Uninstalling readline configuration."

    rm "$config_dir/readline"
}
