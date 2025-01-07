#-------------------------------------------------------------------------------
# Deploy readline configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


readline::install () {
    echo "└> Installing readline configuration."

    force_link "$base_dir/config/readline" "$XDG_CONFIG_HOME/readline"
}

readline::uninstall () {
    echo "└> Uninstalling readline configuration."

    rm "$XDG_CONFIG_HOME/readline"
}
