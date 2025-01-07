#-------------------------------------------------------------------------------
# Deploy miscellaneous scripts
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")


scripts-misc::install () {
    echo "└> Installing miscellaneous scripts."

    ensure_directory "$XDG_SCRIPTS_HOME"
    force_link "$base_dir/config/scripts-misc/count-command-usage.sh" "$XDG_SCRIPTS_HOME/count-command-usage.sh"
    force_link "$base_dir/config/scripts-misc/matrix.sh" "$XDG_SCRIPTS_HOME/matrix.sh"
    force_link "$base_dir/config/scripts-misc/show-webcam.sh" "$XDG_SCRIPTS_HOME/show-webcam.sh"
}

scripts-misc::uninstall () {
    echo "└> Uninstalling miscellaneous scripts."

    rm "$XDG_SCRIPTS_HOME/count-command-usage.sh"
    rm "$XDG_SCRIPTS_HOME/matrix.sh"
    rm "$XDG_SCRIPTS_HOME/show-webcam.sh"
}
