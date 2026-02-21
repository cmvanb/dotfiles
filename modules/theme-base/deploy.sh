#-------------------------------------------------------------------------------
# Deploy theme base configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


theme-base::install () {
    echo "└> Installing theme base configuration."

    ensure_directory "$XDG_CONFIG_HOME/theme"

    local src="$base_dir/modules/theme-base/src"

    force_link "$src/carbon-dark.yaml"  "$XDG_CONFIG_HOME/theme/carbon-dark.yaml"
    force_link "$src/carbon-light.yaml" "$XDG_CONFIG_HOME/theme/carbon-light.yaml"
    force_link "$src/cursor.yaml"       "$XDG_CONFIG_HOME/theme/cursor.yaml"

    # TODO: Select color scheme and fonts based on hostname.
    force_link "$XDG_CONFIG_HOME/theme/carbon-dark.yaml" "$XDG_CONFIG_HOME/theme/colors.yaml"
    force_link "$src/fonts-linux.yaml" "$XDG_CONFIG_HOME/theme/fonts.yaml"

    python3 "$XDG_OPT_HOME/theme/theme.py" parse \
        "$XDG_CONFIG_HOME/theme/colors.yaml" \
        "$XDG_CONFIG_HOME/theme/fonts.yaml" \
        "$XDG_CONFIG_HOME/theme/cursor.yaml"

    render_esh_template "$src/dircolors~esh" "$XDG_CONFIG_HOME/theme/dircolors"
    render_esh_template "$src/eza-colors~esh" "$XDG_CONFIG_HOME/theme/eza-colors"
    render_esh_template "$src/carbon-dark.theme~esh" "$XDG_CONFIG_HOME/theme/carbon-dark.theme"
}

theme-base::uninstall () {
    echo "└> Uninstalling theme base configuration."

    rm -f "$XDG_CONFIG_HOME/theme/carbon-dark.yaml"
    rm -f "$XDG_CONFIG_HOME/theme/carbon-light.yaml"
    rm -f "$XDG_CONFIG_HOME/theme/cursor.yaml"
    rm -f "$XDG_CONFIG_HOME/theme/colors.yaml"
    rm -f "$XDG_CONFIG_HOME/theme/fonts.yaml"

    rm -f "$XDG_CACHE_HOME/theme/theme-data.lua"
    rm -f "$XDG_CACHE_HOME/theme/theme-data.sh"
    rm -f "$XDG_CACHE_HOME/theme/theme-data.fish"

    rm -f "$XDG_CONFIG_HOME/theme/dircolors"
    rm -f "$XDG_CONFIG_HOME/theme/eza-colors"
    rm -f "$XDG_CONFIG_HOME/theme/carbon-dark.theme"
}
