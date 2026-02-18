#-------------------------------------------------------------------------------
# Deploy yazi configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


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

    # Install plugins. Ignore if already installed.
    ya pkg add yazi-rs/plugins:smart-enter 2>/dev/null || true
    ya pkg add ndtoan96/ouch 2>/dev/null || true
    ya pkg add dedukun/bookmarks 2>/dev/null || true
}

yazi::uninstall () {
    echo "└> Uninstalling yazi configuration."

    rm -r "$XDG_CONFIG_HOME/yazi"
}
