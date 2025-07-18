#-------------------------------------------------------------------------------
# Deploy yazi configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


yazi::install () {
    echo "└> Installing yazi configuration."

    ensure_directory "$XDG_CONFIG_HOME/yazi"
    force_link "$base_dir/config/yazi/yazi.toml" "$XDG_CONFIG_HOME/yazi/yazi.toml"
    force_link "$base_dir/config/yazi/keymap.toml" "$XDG_CONFIG_HOME/yazi/keymap.toml"
    force_link "$base_dir/config/yazi/theme.toml" "$XDG_CONFIG_HOME/yazi/theme.toml"
    force_link "$base_dir/config/yazi/yzcd.fish" "$XDG_CONFIG_HOME/yazi/yzcd.fish"
    force_link "$base_dir/config/yazi/yzcd.sh" "$XDG_CONFIG_HOME/yazi/yzcd.sh"

    # Install plugins
    ya pkg add yazi-rs/plugins:smart-enter
    ya pkg add ndtoan96/ouch
}

yazi::uninstall () {
    echo "└> Uninstalling yazi configuration."

    rm -r "$XDG_CONFIG_HOME/yazi"
}
