#-------------------------------------------------------------------------------
# Deploy intelic scripts
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")


scripts-intelic::install () {
    echo "└> Installing intelic scripts."

    ensure_directory "$XDG_SCRIPTS_HOME"
    force_link "$base_dir/config/scripts-intelic/nexus-workspace.sh" "$XDG_SCRIPTS_HOME/nexus-workspace.sh"

    echo "└> Installing intelic shortcuts."

    ensure_directory "$XDG_BIN_HOME"
    force_link "$base_dir/config/scripts-intelic/nexus-workspace.sh" "$XDG_BIN_HOME/ws-nexus"
}

scripts-intelic::uninstall () {
    echo "└> Uninstalling intelic scripts."

    rm "$XDG_SCRIPTS_HOME/nexus-workspace.sh"

    echo "└> Uninstalling intelic shortcuts."

    rm "$XDG_BIN_HOME/ws-nexus"
}
