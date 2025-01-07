#-------------------------------------------------------------------------------
# Deploy river configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
host=$(uname -n)

source "$base_dir/config/lib-shell-utils/fs.sh"


river::install () {
    echo "└> Installing river configuration."

    if [[ $host == "supertubes" || $host == "cyxwel" ]]; then
        force_link "$base_dir/config/river/workspace.sh~home-triple" "$XDG_CONFIG_HOME/river/workspace.sh"

    else
        echo "[$(basename "$0")] ERROR: \`$host\` is not accounted for."
        exit 1
    fi

    mkdir -p "$XDG_CONFIG_HOME/river"
    force_link "$base_dir/config/river/environment.sh" "$XDG_CONFIG_HOME/river/environment.sh"
    force_link "$base_dir/config/river/init" "$XDG_CONFIG_HOME/river/init"
    force_link "$base_dir/config/river/keymaps.sh" "$XDG_CONFIG_HOME/river/keymaps.sh"
    force_link "$base_dir/config/river/send-and-focus-output.sh" "$XDG_CONFIG_HOME/river/send-and-focus-output.sh"
    force_link "$base_dir/config/river/send-to-output.sh" "$XDG_CONFIG_HOME/river/send-to-output.sh"
    force_link "$base_dir/config/river/send-view-to-tag.sh" "$XDG_CONFIG_HOME/river/send-view-to-tag.sh"
    force_link "$base_dir/config/river/theme.sh" "$XDG_CONFIG_HOME/river/theme.sh"
    force_link "$base_dir/config/river/utils.sh" "$XDG_CONFIG_HOME/river/utils.sh"

    mkdir -p "$XDG_CONFIG_HOME/xdg-desktop-portal"
    force_link "$base_dir/config/river/river-portals.conf" "$XDG_CONFIG_HOME/xdg-desktop-portal/river-portals.conf"

    echo "└> Installing river shortcuts."

    mkdir -p "$XDG_BIN_HOME"
    force_link "$base_dir/config/river/river-run.sh" "$XDG_BIN_HOME/river-run"
    force_link "$base_dir/config/river/init~river" "$XDG_BIN_HOME/init"
}

river::uninstall () {
    echo "└> Uninstalling river configuration."

    rm -r "$XDG_CONFIG_HOME/river"

    rm "$XDG_CONFIG_HOME/xdg-desktop-portal/river-portals.conf"

    echo "└> Uninstalling river shortcuts."

    rm "$XDG_BIN_HOME/river-run"
}
