#-------------------------------------------------------------------------------
# Deploy fish configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


fish::install () {
    echo "└> Installing fish configuration."

    mkdir -p "$config_dir/fish"
    force_link "$base_dir/config/fish/config.fish" "$config_dir/fish/config.fish"
    esh "$base_dir/config/fish/env.fish~esh" > "$config_dir/fish/env.fish"
    esh "$base_dir/config/fish/interactive.fish~esh" > "$config_dir/fish/interactive.fish"
    esh "$base_dir/config/fish/login.fish~esh" > "$config_dir/fish/login.fish"
    force_link "$base_dir/config/fish/logout.fish" "$config_dir/fish/logout.fish"
    force_link "$base_dir/config/fish/functions" "$config_dir/fish/functions"
}

fish::uninstall () {
    echo "└> Uninstalling fish configuration."

    rm -r "$config_dir/fish"
}
