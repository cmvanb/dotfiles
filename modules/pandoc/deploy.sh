#-------------------------------------------------------------------------------
# Deploy pandoc configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/modules/lib-shell-utils/src/fs.sh"


pandoc::install () {
    echo "└> Installing pandoc configuration."

    local src="$base_dir/modules/pandoc/src"

    ensure_directory "$XDG_DATA_HOME/pandoc/templates"

    force_link "$src/templates/default.html5" "$XDG_DATA_HOME/pandoc/templates/default.html5"
    esh "$src/templates/github-pandoc.css~esh" > "$XDG_DATA_HOME/pandoc/templates/github-pandoc.css"
}

pandoc::uninstall () {
    echo "└> Uninstalling pandoc configuration."

    rm -r "$XDG_DATA_HOME/pandoc/templates"
}
