#-------------------------------------------------------------------------------
# Deploy fish configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


fish::install () {
    echo "└> Installing fish configuration."

    ensure_directory "$XDG_CONFIG_HOME/fish"
    force_link "$base_dir/config/fish/config.fish" "$XDG_CONFIG_HOME/fish/config.fish"
    esh "$base_dir/config/fish/env.fish~esh" > "$XDG_CONFIG_HOME/fish/env.fish"
    esh "$base_dir/config/fish/interactive.fish~esh" > "$XDG_CONFIG_HOME/fish/interactive.fish"
    esh "$base_dir/config/fish/login.fish~esh" > "$XDG_CONFIG_HOME/fish/login.fish"
    force_link "$base_dir/config/fish/logout.fish" "$XDG_CONFIG_HOME/fish/logout.fish"
    force_link "$base_dir/config/fish/functions" "$XDG_CONFIG_HOME/fish/functions"
}

fish::uninstall () {
    echo "└> Uninstalling fish configuration."

    rm -r "$XDG_CONFIG_HOME/fish"
}
