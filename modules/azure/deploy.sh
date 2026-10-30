#-------------------------------------------------------------------------------
# Deploy azure configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


azure::install () {
    echo "└> Installing azure configuration."

    local src="$base_dir/modules/azure/src"

    fs::force_link "$src/bash/azure.sh"   "$XDG_CONFIG_HOME/bash/conf.d/azure.sh"
    fs::force_link "$src/fish/azure.fish" "$XDG_CONFIG_HOME/fish/conf.d/azure.fish"
}

azure::uninstall () {
    echo "└> Uninstalling azure configuration."

    rm -f "$XDG_CONFIG_HOME/bash/conf.d/azure.sh"
    rm -f "$XDG_CONFIG_HOME/fish/conf.d/azure.fish"
}
