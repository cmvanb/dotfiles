#-------------------------------------------------------------------------------
# Deploy discord configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


discord::install () {
    echo "└> Installing discord configuration."

    mkdir -p "$XDG_DATA_HOME/applications"
    force_link "$base_dir/config/discord/discord.desktop" "$XDG_DATA_HOME/applications/discord.desktop"
}

discord::uninstall () {
    echo "└> Uninstalling discord configuration."

    rm "$XDG_DATA_HOME/applications/discord.desktop"
}
