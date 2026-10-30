#-------------------------------------------------------------------------------
# Deploy dart configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


dart::install () {
    echo "└> Installing dart configuration."

    local src="$base_dir/modules/dart/src"

    fs::force_link "$src/bash/dart.sh"   "$XDG_CONFIG_HOME/bash/conf.d/dart.sh"
    fs::force_link "$src/fish/dart.fish" "$XDG_CONFIG_HOME/fish/conf.d/dart.fish"
}

dart::uninstall () {
    echo "└> Uninstalling dart configuration."

    rm -f "$XDG_CONFIG_HOME/bash/conf.d/dart.sh"
    rm -f "$XDG_CONFIG_HOME/fish/conf.d/dart.fish"
}
