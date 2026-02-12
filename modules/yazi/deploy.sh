#-------------------------------------------------------------------------------
# Deploy yazi configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/modules/lib-shell-utils/src/fs.sh"


yazi::install () {
    echo "└> Installing yazi configuration."

    local src="$base_dir/modules/yazi/src"

    ensure_directory "$XDG_CONFIG_HOME/yazi"
    force_link "$src/init.lua" "$XDG_CONFIG_HOME/yazi/init.lua"
    force_link "$src/yazi.toml" "$XDG_CONFIG_HOME/yazi/yazi.toml"
    force_link "$src/keymap.toml" "$XDG_CONFIG_HOME/yazi/keymap.toml"
    force_link "$src/theme.toml" "$XDG_CONFIG_HOME/yazi/theme.toml"
    force_link "$src/yzcd.fish" "$XDG_CONFIG_HOME/yazi/yzcd.fish"
    force_link "$src/yzcd.sh" "$XDG_CONFIG_HOME/yazi/yzcd.sh"

    # Install plugins
    ya pkg add yazi-rs/plugins:smart-enter
    ya pkg add ndtoan96/ouch
    ya pkg add dedukun/bookmarks
}

yazi::uninstall () {
    echo "└> Uninstalling yazi configuration."

    rm -r "$XDG_CONFIG_HOME/yazi"
}
