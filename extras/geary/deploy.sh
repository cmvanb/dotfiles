script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"

geary::install() {
    echo "└> Installing geary configuration."

    local src="$base_dir/modules/geary/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/geary"
    template::render_mako "$src/user-message.css.mako" "$XDG_CONFIG_HOME/geary/user-message.css"
}

geary::uninstall() {
    echo "└> Uninstalling geary configuration."

    rm -f "$XDG_CONFIG_HOME/geary/user-message.css"
}
