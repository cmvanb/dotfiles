#-------------------------------------------------------------------------------
# Deploy theme base configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/modules/lib-shell-utils/src/fs.sh"


theme-base::install () {
    echo "└> Installing theme base configuration."

    ensure_directory "$XDG_CONFIG_HOME/theme"
    force_link "$base_dir/modules/theme/src/carbon-dark" "$XDG_CONFIG_HOME/theme/carbon-dark"
    force_link "$base_dir/modules/theme/src/carbon-light" "$XDG_CONFIG_HOME/theme/carbon-light"

    # TODO: Use a symlink with hostname suffix to point to the correct color profile.
    force_link "$XDG_CONFIG_HOME/theme/carbon-dark" "$XDG_CONFIG_HOME/theme/colors"

    ensure_directory "$XDG_CONFIG_HOME/theme"
    esh "$base_dir/modules/theme/src/dircolors~esh" > "$XDG_CONFIG_HOME/theme/dircolors"
    esh "$base_dir/modules/theme/src/eza-colors~esh" > "$XDG_CONFIG_HOME/theme/eza-colors"
    esh "$base_dir/modules/theme/src/carbon-dark.theme~esh" > "$XDG_CONFIG_HOME/theme/carbon-dark.theme"

    "$XDG_OPT_HOME/theme/color-lookup-256-index.sh" --cache

    source "$XDG_OPT_HOME/theme/configure-dircolors.sh"
}

theme-base::uninstall () {
    echo "└> Uninstalling theme base configuration."

    rm "$XDG_CONFIG_HOME/theme/carbon-dark"
    rm "$XDG_CONFIG_HOME/theme/carbon-light"

    rm "$XDG_CONFIG_HOME/theme/colors"

    rm "$XDG_CONFIG_HOME/theme/dircolors"
    rm "$XDG_CONFIG_HOME/theme/eza-colors"
    rm "$XDG_CONFIG_HOME/theme/carbon-dark.theme"
}
