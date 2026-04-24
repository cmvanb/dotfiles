#-------------------------------------------------------------------------------
# Deploy shell utility scripts
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


scripts-shell-utils::install () {
    echo "└> Installing shell utility scripts."

    local src="$base_dir/modules/scripts-shell-utils/src"

    fs::ensure_directory "$XDG_SCRIPTS_HOME"
    fs::force_link "$src/clean-home.sh" "$XDG_SCRIPTS_HOME/clean-home.sh"
    fs::force_link "$src/edit.sh" "$XDG_SCRIPTS_HOME/edit.sh"
    fs::force_link "$src/estimate-disk-space-usage.sh" "$XDG_SCRIPTS_HOME/estimate-disk-space-usage.sh"
    fs::force_link "$src/format-text.sh" "$XDG_SCRIPTS_HOME/format-text.sh"
    fs::force_link "$src/interactive-grep.sh" "$XDG_SCRIPTS_HOME/interactive-grep.sh"
    fs::force_link "$src/kebabify.sh" "$XDG_SCRIPTS_HOME/kebabify.sh"
    fs::force_link "$src/lsds.py" "$XDG_SCRIPTS_HOME/lsds.py"
    fs::force_link "$src/print-environment.py" "$XDG_SCRIPTS_HOME/print-environment.py"
    fs::force_link "$src/print-terminal-colors.sh" "$XDG_SCRIPTS_HOME/print-terminal-colors.sh"
    fs::force_link "$src/rename-kebabcase.sh" "$XDG_SCRIPTS_HOME/rename-kebabcase.sh"
    fs::force_link "$src/set-terminal-title.sh" "$XDG_SCRIPTS_HOME/set-terminal-title.sh"
    fs::force_link "$src/show-path.sh" "$XDG_SCRIPTS_HOME/show-path.sh"
    fs::force_link "$src/terminal-preview.sh" "$XDG_SCRIPTS_HOME/terminal-preview.sh"
    fs::force_link "$src/view.sh" "$XDG_SCRIPTS_HOME/view.sh"

    echo "└> Installing shell utility shortcuts."

    fs::ensure_directory "$XDG_BIN_HOME"
    fs::force_link "$src/edit.sh" "$XDG_BIN_HOME/edit"
    fs::force_link "$src/rename-kebabcase.sh" "$XDG_BIN_HOME/kebab"
    fs::force_link "$src/lsds.py" "$XDG_BIN_HOME/lsds"
    fs::force_link "$src/kebabify.sh" "$XDG_BIN_HOME/kebabify"
    fs::force_link "$src/print-environment.py" "$XDG_BIN_HOME/printenv"
    fs::force_link "$src/view.sh" "$XDG_BIN_HOME/view"
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
