#-------------------------------------------------------------------------------
# Deploy opencode configuration
#-------------------------------------------------------------------------------

script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"

opencode::install () {
    echo "└> Installing opencode configuration."

    local src="$base_dir/modules/opencode/src"

    ensure_directory "$XDG_CONFIG_HOME/opencode"
    force_link "$src/opencode.json" "$XDG_CONFIG_HOME/opencode/opencode.json"
}

opencode::uninstall () {
    echo "└> Uninstalling opencode configuration."

    rm "$XDG_CONFIG_HOME/opencode/opencode.json"
}
