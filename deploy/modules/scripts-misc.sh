#-------------------------------------------------------------------------------
# Deploy miscellaneous scripts
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")


scripts-misc::install () {
    echo "└> Installing miscellaneous scripts."

    mkdir -p "$XDG_SCRIPTS_HOME"
    force_link "$base_dir/local/scripts/count-command-usage.sh" "$XDG_SCRIPTS_HOME/count-command-usage.sh"
    force_link "$base_dir/local/scripts/matrix.sh" "$XDG_SCRIPTS_HOME/matrix.sh"
    force_link "$base_dir/local/scripts/show-webcam.sh" "$XDG_SCRIPTS_HOME/show-webcam.sh"
}

scripts-misc::uninstall () {
    echo "└> Uninstalling miscellaneous scripts."

    rm "$XDG_SCRIPTS_HOME/count-command-usage.sh"
    rm "$XDG_SCRIPTS_HOME/matrix.sh"
    rm "$XDG_SCRIPTS_HOME/show-webcam.sh"
}
