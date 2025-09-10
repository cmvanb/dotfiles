#-------------------------------------------------------------------------------
# Deploy bitwarden configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")


bitwarden::install () {
    echo "└> Installing bitwarden configuration."

    ensure_directory "$XDG_CONFIG_HOME/Bitwarden"
    # NOTE: Don't symlink Bitwarden config because it will be overwritten by the app.
    cp -n "$base_dir/config/bitwarden/data.json" "$XDG_CONFIG_HOME/Bitwarden/data.json" && true

    ensure_directory "$XDG_DATA_HOME/applications"
    force_link "$base_dir/config/bitwarden/bitwarden.desktop" "$XDG_DATA_HOME/applications/bitwarden.desktop"
}

bitwarden::uninstall () {
    echo "└> Uninstalling bitwarden configuration."

    rm -r "$XDG_CONFIG_HOME/Bitwarden/data.json"

    rm "$XDG_DATA_HOME/applications/bitwarden.desktop"
}
