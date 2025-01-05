#-------------------------------------------------------------------------------
# Deploy markdown scripts
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
scripts_dir=${XDG_SCRIPTS_HOME:-$HOME/.local/scripts}


scripts-markdown::install () {
    echo "└> Installing markdown scripts."

    mkdir -p "$scripts_dir"
    force_link "$base_dir/local/scripts/markdown-to-html.sh" "$scripts_dir/markdown-to-html.sh"
    force_link "$base_dir/local/scripts/preview-markdown.sh" "$scripts_dir/preview-markdown.sh"
}

scripts-markdown::uninstall () {
    echo "└> Uninstalling markdown scripts."

    rm "$scripts_dir/markdown-to-html.sh"
    rm "$scripts_dir/preview-markdown.sh"
}
