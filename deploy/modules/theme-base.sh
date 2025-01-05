#-------------------------------------------------------------------------------
# Deploy theme base configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
opt_dir=${XDG_OPT_HOME:-$HOME/.local/opt}

source "$base_dir/local/opt/shell-utils/fs.sh"


theme-base::install () {
    echo "└> Installing theme base configuration."

    mkdir -p "$config_dir/theme"
    force_link "$base_dir/config/theme/carbon-dark" "$config_dir/theme/carbon-dark"
    force_link "$base_dir/config/theme/carbon-light" "$config_dir/theme/carbon-light"

    force_link "$config_dir/theme/carbon-dark" "$config_dir/theme/colors"

    mkdir -p "$config_dir/theme"
    esh "$base_dir/config/theme/dircolors~esh" > "$config_dir/theme/dircolors"
    esh "$base_dir/config/theme/eza-colors~esh" > "$config_dir/theme/eza-colors"

    "$opt_dir/theme/color-lookup-256-index.sh" --cache

    source "$opt_dir/theme/configure-dircolors.sh"
}

theme-base::uninstall () {
    echo "└> Uninstalling theme base configuration."

    rm "$config_dir/theme/carbon-dark"
    rm "$config_dir/theme/carbon-light"

    rm "$config_dir/theme/colors"

    rm "$config_dir/theme/dircolors"
    rm "$config_dir/theme/eza-colors"
}
