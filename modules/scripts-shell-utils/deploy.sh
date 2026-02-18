#-------------------------------------------------------------------------------
# Deploy shell utility scripts
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


scripts-shell-utils::install () {
    echo "└> Installing shell utility scripts."

    local src="$base_dir/modules/scripts-shell-utils/src"

    ensure_directory "$XDG_SCRIPTS_HOME"
    force_link "$src/clean-home.sh" "$XDG_SCRIPTS_HOME/clean-home.sh"
    force_link "$src/edit.sh" "$XDG_SCRIPTS_HOME/edit.sh"
    force_link "$src/estimate-disk-space-usage.sh" "$XDG_SCRIPTS_HOME/estimate-disk-space-usage.sh"
    force_link "$src/format-text.sh" "$XDG_SCRIPTS_HOME/format-text.sh"
    force_link "$src/interactive-grep.sh" "$XDG_SCRIPTS_HOME/interactive-grep.sh"
    force_link "$src/kebabify.sh" "$XDG_SCRIPTS_HOME/kebabify.sh"
    force_link "$src/lsds.py" "$XDG_SCRIPTS_HOME/lsds.py"
    force_link "$src/print-environment.py" "$XDG_SCRIPTS_HOME/print-environment.py"
    force_link "$src/print-terminal-colors.sh" "$XDG_SCRIPTS_HOME/print-terminal-colors.sh"
    force_link "$src/rename-kebabcase.sh" "$XDG_SCRIPTS_HOME/rename-kebabcase.sh"
    force_link "$src/set-terminal-title.sh" "$XDG_SCRIPTS_HOME/set-terminal-title.sh"
    force_link "$src/show-path.sh" "$XDG_SCRIPTS_HOME/show-path.sh"
    force_link "$src/terminal-preview.sh" "$XDG_SCRIPTS_HOME/terminal-preview.sh"
    force_link "$src/view.sh" "$XDG_SCRIPTS_HOME/view.sh"

    echo "└> Installing shell utility shortcuts."

    ensure_directory "$XDG_BIN_HOME"
    force_link "$src/edit.sh" "$XDG_BIN_HOME/edit"
    force_link "$src/rename-kebabcase.sh" "$XDG_BIN_HOME/kebab"
    force_link "$src/lsds.py" "$XDG_BIN_HOME/lsds"
    force_link "$src/kebabify.sh" "$XDG_BIN_HOME/kebabify"
    force_link "$src/print-environment.py" "$XDG_BIN_HOME/printenv"
    force_link "$src/view.sh" "$XDG_BIN_HOME/view"
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
