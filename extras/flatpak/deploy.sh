#-------------------------------------------------------------------------------
# Deploy flatpak
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
source "$base_dir/lib/fs.sh"


flatpak::install () {
    echo "└> Installing flatpak configuration."

    local src="$base_dir/modules/flatpak/src"

    ensure_directory "$XDG_SCRIPTS_HOME"
    force_link "$src/flatpak-run.sh" "$XDG_SCRIPTS_HOME/flatpak-run.sh"

    ensure_directory "$XDG_BIN_HOME"
    force_link "$src/flatpak-run.sh" "$XDG_BIN_HOME/flatpak-run"
}

flatpak::uninstall () {
    echo "└> Uninstalling flatpak configuration."

    rm "$XDG_SCRIPTS_HOME/flatpak-run.sh"
    rm "$XDG_BIN_HOME/flatpak-run"
}
