#-------------------------------------------------------------------------------
# Deploy shell utility scripts
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


scripts-shell-utils::install () {
    echo "└> Installing shell utility scripts."

    ensure_directory "$XDG_SCRIPTS_HOME"
    force_link "$base_dir/config/scripts-shell-utils/clean-home.sh" "$XDG_SCRIPTS_HOME/clean-home.sh"
    force_link "$base_dir/config/scripts-shell-utils/edit.sh" "$XDG_SCRIPTS_HOME/edit.sh"
    force_link "$base_dir/config/scripts-shell-utils/estimate-disk-space-usage.sh" "$XDG_SCRIPTS_HOME/estimate-disk-space-usage.sh"
    force_link "$base_dir/config/scripts-shell-utils/format-text.sh" "$XDG_SCRIPTS_HOME/format-text.sh"
    force_link "$base_dir/config/scripts-shell-utils/interactive-grep.sh" "$XDG_SCRIPTS_HOME/interactive-grep.sh"
    force_link "$base_dir/config/scripts-shell-utils/kebabify.sh" "$XDG_SCRIPTS_HOME/kebabify.sh"
    force_link "$base_dir/config/scripts-shell-utils/lsds.py" "$XDG_SCRIPTS_HOME/lsds.py"
    force_link "$base_dir/config/scripts-shell-utils/print-environment.py" "$XDG_SCRIPTS_HOME/print-environment.py"
    force_link "$base_dir/config/scripts-shell-utils/print-terminal-colors.sh" "$XDG_SCRIPTS_HOME/print-terminal-colors.sh"
    force_link "$base_dir/config/scripts-shell-utils/rename-kebabcase.sh" "$XDG_SCRIPTS_HOME/rename-kebabcase.sh"
    force_link "$base_dir/config/scripts-shell-utils/set-terminal-title.sh" "$XDG_SCRIPTS_HOME/set-terminal-title.sh"
    force_link "$base_dir/config/scripts-shell-utils/show-path.sh" "$XDG_SCRIPTS_HOME/show-path.sh"
    force_link "$base_dir/config/scripts-shell-utils/terminal-preview.sh" "$XDG_SCRIPTS_HOME/terminal-preview.sh"
    force_link "$base_dir/config/scripts-shell-utils/view.sh" "$XDG_SCRIPTS_HOME/view.sh"

    echo "└> Installing shell utility shortcuts."

    ensure_directory "$XDG_BIN_HOME"
    force_link "$base_dir/config/scripts-shell-utils/edit.sh" "$XDG_BIN_HOME/edit"
    force_link "$base_dir/config/scripts-shell-utils/rename-kebabcase.sh" "$XDG_BIN_HOME/kebab"
    force_link "$base_dir/config/scripts-shell-utils/lsds.py" "$XDG_BIN_HOME/lsds"
    force_link "$base_dir/config/scripts-shell-utils/kebabify.sh" "$XDG_BIN_HOME/kebabify"
    force_link "$base_dir/config/scripts-shell-utils/print-environment.py" "$XDG_BIN_HOME/printenv"
    force_link "$base_dir/config/scripts-shell-utils/view.sh" "$XDG_BIN_HOME/view"
}

scripts-shell-utils::uninstall () {
    echo "└> Uninstalling shell utility scripts."

    rm "$XDG_SCRIPTS_HOME/clean-home.sh"
    rm "$XDG_SCRIPTS_HOME/estimate-disk-space-usage.sh"
    rm "$XDG_SCRIPTS_HOME/format-text.sh"
    rm "$XDG_SCRIPTS_HOME/interactive-grep.sh"
    rm "$XDG_SCRIPTS_HOME/kebabify.sh"
    rm "$XDG_SCRIPTS_HOME/print-environment.py"
    rm "$XDG_SCRIPTS_HOME/print-terminal-colors.sh"
    rm "$XDG_SCRIPTS_HOME/rename-kebabcase.sh"
    rm "$XDG_SCRIPTS_HOME/set-terminal-title.sh"
    rm "$XDG_SCRIPTS_HOME/show-path.sh"
    rm "$XDG_SCRIPTS_HOME/terminal-preview.sh"
    rm "$XDG_SCRIPTS_HOME/view.sh"

    echo "└> Uninstalling shell utility shortcuts."

    rm "$XDG_BIN_HOME/edit"
    rm "$XDG_BIN_HOME/kebab"
    rm "$XDG_BIN_HOME/kebabify"
    rm "$XDG_BIN_HOME/printenv"
    rm "$XDG_BIN_HOME/view"
}
