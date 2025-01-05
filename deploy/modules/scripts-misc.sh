#-------------------------------------------------------------------------------
# Deploy miscellaneous scripts
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
scripts_dir=${XDG_SCRIPTS_HOME:-$HOME/.local/scripts}


scripts-misc::install () {
    echo "└> Installing miscellaneous scripts."

    mkdir -p "$scripts_dir"
    force_link "$base_dir/local/scripts/count-command-usage.sh" "$scripts_dir/count-command-usage.sh"
    force_link "$base_dir/local/scripts/matrix.sh" "$scripts_dir/matrix.sh"
    force_link "$base_dir/local/scripts/show-webcam.sh" "$scripts_dir/show-webcam.sh"
}

scripts-misc::uninstall () {
    echo "└> Uninstalling miscellaneous scripts."

    rm "$scripts_dir/count-command-usage.sh"
    rm "$scripts_dir/matrix.sh"
    rm "$scripts_dir/show-webcam.sh"
}
