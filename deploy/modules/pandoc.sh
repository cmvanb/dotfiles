#-------------------------------------------------------------------------------
# Deploy pandoc configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


pandoc::install () {
    echo "└> Installing pandoc configuration."

    ensure_directory "$XDG_DATA_HOME/pandoc/templates"

    force_link "$base_dir/config/pandoc/templates/default.html5" "$XDG_DATA_HOME/pandoc/templates/default.html5"
    esh "$base_dir/config/pandoc/templates/github-pandoc.css~esh" > "$XDG_DATA_HOME/pandoc/templates/github-pandoc.css"
}

pandoc::uninstall () {
    echo "└> Uninstalling pandoc configuration."

    rm -r "$XDG_DATA_HOME/pandoc/templates"
}
