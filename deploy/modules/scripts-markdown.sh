#-------------------------------------------------------------------------------
# Deploy markdown scripts
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")


scripts-markdown::install () {
    echo "└> Installing markdown scripts."

    mkdir -p "$XDG_SCRIPTS_HOME"
    force_link "$base_dir/local/scripts/markdown-to-html.sh" "$XDG_SCRIPTS_HOME/markdown-to-html.sh"
    force_link "$base_dir/local/scripts/preview-markdown.sh" "$XDG_SCRIPTS_HOME/preview-markdown.sh"
}

scripts-markdown::uninstall () {
    echo "└> Uninstalling markdown scripts."

    rm "$XDG_SCRIPTS_HOME/markdown-to-html.sh"
    rm "$XDG_SCRIPTS_HOME/preview-markdown.sh"
}