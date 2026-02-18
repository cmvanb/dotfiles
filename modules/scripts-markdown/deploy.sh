#-------------------------------------------------------------------------------
# Deploy markdown scripts
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
source "$base_dir/lib/fs.sh"


scripts-markdown::install () {
    echo "└> Installing markdown scripts."

    local src="$base_dir/modules/scripts-markdown/src"

    ensure_directory "$XDG_SCRIPTS_HOME"
    force_link "$src/markdown-to-html.sh" "$XDG_SCRIPTS_HOME/markdown-to-html.sh"
    force_link "$src/preview-markdown.sh" "$XDG_SCRIPTS_HOME/preview-markdown.sh"
}

scripts-markdown::uninstall () {
    echo "└> Uninstalling markdown scripts."

    rm "$XDG_SCRIPTS_HOME/markdown-to-html.sh"
    rm "$XDG_SCRIPTS_HOME/preview-markdown.sh"
}
