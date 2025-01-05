#-------------------------------------------------------------------------------
# Deploy bitwarden configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
data_dir=${XDG_DATA_HOME:-$HOME/.local/share}


bitwarden::install () {
    echo "└> Installing bitwarden configuration."

    mkdir -p "$config_dir/Bitwarden"
    # NOTE: Don't symlink Bitwarden config because it will be overwritten by the app.
    cp -n "$base_dir/config/Bitwarden/data.json" "$config_dir/Bitwarden/data.json" && true

    mkdir -p "$data_dir/applications"
    force_link "$base_dir/local/share/applications/bitwarden.desktop" "$data_dir/applications/bitwarden.desktop"
}

bitwarden::uninstall () {
    echo "└> Uninstalling bitwarden configuration."

    rm -r "$config_dir/Bitwarden/data.json"

    rm "$data_dir/applications/bitwarden.desktop"
}
