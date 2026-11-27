#-------------------------------------------------------------------------------
# Deploy go configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


go::install () {
    echo "└> Installing go configuration."

    local src="$base_dir/modules/go/src"

    fs::force_link "$src/bash/go.sh"   "$XDG_CONFIG_HOME/bash/conf.d/go.sh"
    fs::force_link "$src/fish/go.fish" "$XDG_CONFIG_HOME/fish/conf.d/go.fish"
}

go::uninstall () {
    echo "└> Uninstalling go configuration."

    fs::remove "$XDG_CONFIG_HOME/bash/conf.d/go.sh"
    fs::remove "$XDG_CONFIG_HOME/fish/conf.d/go.fish"
}
