#-------------------------------------------------------------------------------
# Deploy pandoc configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


pandoc::install () {
    echo "└> Installing pandoc configuration."

    local src="$base_dir/modules/pandoc/src"

    fs::ensure_directory "$XDG_DATA_HOME/pandoc/templates"

    fs::force_link "$src/templates/default.html5" "$XDG_DATA_HOME/pandoc/templates/default.html5"
    template::render_mako "$src/templates/markdown.mako.css" "$XDG_DATA_HOME/pandoc/templates/markdown.css"
}

pandoc::uninstall () {
    echo "└> Uninstalling pandoc configuration."

    rm -r "$XDG_DATA_HOME/pandoc/templates"
}
