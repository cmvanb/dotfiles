#-------------------------------------------------------------------------------
# Deploy niri configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
host=$(uname -n)

source "$base_dir/local/opt/shell-utils/fs.sh"


niri::install () {
    echo "└> Installing niri configuration."

    mkdir -p "$config_dir/niri"
    force_link "$base_dir/config/niri/config.kdl" "$config_dir/niri/config.kdl"
    force_link "$base_dir/config/niri/focus-window.sh" "$config_dir/niri/focus-window.sh"

    mkdir -p "$config_dir/systemd/user/niri.service.wants"
    force_link "/usr/lib/systemd/user/mako.service" "$config_dir/systemd/user/niri.service.wants/mako.service"
    force_link "/usr/lib/systemd/user/waybar.service" "$config_dir/systemd/user/niri.service.wants/waybar.service"

    if [[ $host == "supertubes" || $host == "cyxwel" ]]; then
        force_link "$base_dir/config/niri/workspace.sh~home-triple" "$config_dir/niri/workspace.sh"

    else
        echo "[$(basename "$0")] ERROR: \`$host\` is not accounted for."
        exit 1
    fi
}

niri::uninstall () {
    echo "└> Uninstalling niri configuration."

    rm -r "$config_dir/niri"
    rm -r "$config_dir/systemd/user/niri.service.wants"
}
