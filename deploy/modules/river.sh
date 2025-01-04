#-------------------------------------------------------------------------------
# Deploy river configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
host=$(uname -n)

source "$base_dir/local/opt/shell-utils/fs.sh"


river::install () {
    echo "└> Installing river configuration."

    mkdir -p "$config_dir/river"
    force_link "$base_dir/config/river/environment.sh" "$config_dir/river/environment.sh"
    force_link "$base_dir/config/river/init" "$config_dir/river/init"
    force_link "$base_dir/config/river/keymaps.sh" "$config_dir/river/keymaps.sh"
    force_link "$base_dir/config/river/send-and-focus-output.sh" "$config_dir/river/send-and-focus-output.sh"
    force_link "$base_dir/config/river/send-to-output.sh" "$config_dir/river/send-to-output.sh"
    force_link "$base_dir/config/river/send-view-to-tag.sh" "$config_dir/river/send-view-to-tag.sh"
    force_link "$base_dir/config/river/theme.sh" "$config_dir/river/theme.sh"
    force_link "$base_dir/config/river/utils.sh" "$config_dir/river/utils.sh"

    if [[ $host == "supertubes" || $host == "cyxwel" ]]; then
        force_link "$base_dir/config/river/workspace.sh~home-triple" "$config_dir/river/workspace.sh"

    else
        echo "[$(basename "$0")] ERROR: \`$host\` is not accounted for."
        exit 1
    fi
}

river::uninstall () {
    echo "└> Uninstalling river configuration."

    rm -r "$config_dir/river"
}