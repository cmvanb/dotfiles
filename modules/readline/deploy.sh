#-------------------------------------------------------------------------------
# Deploy readline configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/modules/lib-shell-utils/src/fs.sh"


readline::install () {
    echo "└> Installing readline configuration."

    local src="$base_dir/modules/readline/src"

    force_link "$src" "$XDG_CONFIG_HOME/readline"
}

readline::uninstall () {
    echo "└> Uninstalling readline configuration."

    rm "$XDG_CONFIG_HOME/readline"
}
