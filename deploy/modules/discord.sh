#-------------------------------------------------------------------------------
# Deploy discord configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
data_dir=${XDG_DATA_HOME:-$HOME/.local/share}

source "$base_dir/local/opt/shell-utils/fs.sh"


discord::install () {
    echo "└> Installing discord configuration."

    mkdir -p "$data_dir/applications"
    force_link "$base_dir/local/share/applications/discord.desktop" "$data_dir/applications/discord.desktop"
}

discord::uninstall () {
    echo "└> Uninstalling discord configuration."

    rm "$data_dir/applications/discord.desktop"
}
