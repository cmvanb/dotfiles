#-------------------------------------------------------------------------------
# Deploy discord configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/modules/lib-shell-utils/src/fs.sh"


discord::install () {
    echo "└> Installing discord configuration."

    local src="$base_dir/modules/discord/src"

    ensure_directory "$XDG_DATA_HOME/applications"
    force_link "$src/discord.desktop" "$XDG_DATA_HOME/applications/discord.desktop"
}

discord::uninstall () {
    echo "└> Uninstalling discord configuration."

    rm "$XDG_DATA_HOME/applications/discord.desktop"
}
