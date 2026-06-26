script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"

worktrunk::install() {
    assert_dependency wt

    local src="$base_dir/modules/worktrunk/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/worktrunk"
    fs::force_link "$src/config.toml" "$XDG_CONFIG_HOME/worktrunk/config.toml"
}

worktrunk::uninstall() {
    rm -f "$XDG_CONFIG_HOME/worktrunk/config.toml"
}
