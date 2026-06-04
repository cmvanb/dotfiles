#-------------------------------------------------------------------------------
# Deploy rust configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


rust::install () {
    echo "└> Installing rust configuration."

    local src="$base_dir/modules/rust/src"

    fs::force_link "$src/bash/rust.sh"   "$XDG_CONFIG_HOME/bash/conf.d/rust.sh"
    fs::force_link "$src/fish/rust.fish" "$XDG_CONFIG_HOME/fish/conf.d/rust.fish"
}

rust::uninstall () {
    echo "└> Uninstalling rust configuration."

    rm -f "$XDG_CONFIG_HOME/bash/conf.d/rust.sh"
    rm -f "$XDG_CONFIG_HOME/fish/conf.d/rust.fish"
}
