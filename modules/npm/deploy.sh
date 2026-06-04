#-------------------------------------------------------------------------------
# Deploy npm configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


npm::install () {
    echo "└> Installing npm configuration."

    local src="$base_dir/modules/npm/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/npm"
    fs::force_link "$src/npmrc"          "$XDG_CONFIG_HOME/npm/npmrc"
    fs::force_link "$src/bash/npm.sh"   "$XDG_CONFIG_HOME/bash/conf.d/npm.sh"
    fs::force_link "$src/fish/npm.fish" "$XDG_CONFIG_HOME/fish/conf.d/npm.fish"
}

npm::uninstall () {
    echo "└> Uninstalling npm configuration."

    rm -f "$XDG_CONFIG_HOME/npm/npmrc"
    rmdir "$XDG_CONFIG_HOME/npm" 2>/dev/null || true
    rm -f "$XDG_CONFIG_HOME/bash/conf.d/npm.sh"
    rm -f "$XDG_CONFIG_HOME/fish/conf.d/npm.fish"
}
