#-------------------------------------------------------------------------------
# Deploy bitwarden configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}


bitwarden::install () {
    echo "└> Installing bitwarden configuration."

    mkdir -p "$config_dir/Bitwarden"
    # NOTE: Don't symlink Bitwarden config because it will be overwritten by the app.
    cp -n "$base_dir/config/Bitwarden/data.json" "$config_dir/Bitwarden/data.json" && true
}

bitwarden::uninstall () {
    echo "└> Uninstalling bitwarden configuration."

    rm -r "$config_dir/Bitwarden/data.json"
}
