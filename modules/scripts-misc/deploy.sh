#-------------------------------------------------------------------------------
# Deploy miscellaneous scripts
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")


scripts-misc::install () {
    echo "└> Installing miscellaneous scripts."

    local src="$base_dir/modules/scripts-misc/src"

    ensure_directory "$XDG_SCRIPTS_HOME"
    force_link "$src/count-command-usage.sh" "$XDG_SCRIPTS_HOME/count-command-usage.sh"
    force_link "$src/matrix.sh" "$XDG_SCRIPTS_HOME/matrix.sh"
    force_link "$src/show-webcam.sh" "$XDG_SCRIPTS_HOME/show-webcam.sh"
}

scripts-misc::uninstall () {
    echo "└> Uninstalling miscellaneous scripts."

    rm "$XDG_SCRIPTS_HOME/count-command-usage.sh"
    rm "$XDG_SCRIPTS_HOME/matrix.sh"
    rm "$XDG_SCRIPTS_HOME/show-webcam.sh"
}
