#-------------------------------------------------------------------------------
# Deploy shell utility scripts
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
scripts_dir=${XDG_SCRIPTS_HOME:-$HOME/.local/scripts}

source "$base_dir/local/opt/shell-utils/fs.sh"


scripts-shell-utils::install () {
    echo "└> Installing shell utility scripts."

    mkdir -p "$scripts_dir"
    force_link "$base_dir/local/scripts/clean-home.sh" "$scripts_dir/clean-home.sh"
    force_link "$base_dir/local/scripts/estimate-disk-space-usage.sh" "$scripts_dir/estimate-disk-space-usage.sh"
    force_link "$base_dir/local/scripts/format-text.sh" "$scripts_dir/format-text.sh"
    force_link "$base_dir/local/scripts/interactive-grep.sh" "$scripts_dir/interactive-grep.sh"
    force_link "$base_dir/local/scripts/kebabify.sh" "$scripts_dir/kebabify.sh"
    force_link "$base_dir/local/scripts/print-environment.py" "$scripts_dir/print-environment.py"
    force_link "$base_dir/local/scripts/print-terminal-colors.sh" "$scripts_dir/print-terminal-colors.sh"
    force_link "$base_dir/local/scripts/rename-kebabcase.sh" "$scripts_dir/rename-kebabcase.sh"
    force_link "$base_dir/local/scripts/set-terminal-title.sh" "$scripts_dir/set-terminal-title.sh"
    force_link "$base_dir/local/scripts/show-path.sh" "$scripts_dir/show-path.sh"
    force_link "$base_dir/local/scripts/terminal-preview.sh" "$scripts_dir/terminal-preview.sh"
    force_link "$base_dir/local/scripts/view.sh" "$scripts_dir/view.sh"
}

scripts-shell-utils::uninstall () {
    echo "└> Uninstalling shell utility scripts."

    rm "$scripts_dir/clean-home.sh"
    rm "$scripts_dir/estimate-disk-space-usage.sh"
    rm "$scripts_dir/format-text.sh"
    rm "$scripts_dir/interactive-grep.sh"
    rm "$scripts_dir/kebabify.sh"
    rm "$scripts_dir/print-environment.py"
    rm "$scripts_dir/print-terminal-colors.sh"
    rm "$scripts_dir/rename-kebabcase.sh"
    rm "$scripts_dir/set-terminal-title.sh"
    rm "$scripts_dir/show-path.sh"
    rm "$scripts_dir/terminal-preview.sh"
    rm "$scripts_dir/view.sh"
}
