#-------------------------------------------------------------------------------
# Deploy theme base configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


theme-base::install () {
    echo "└> Installing theme base configuration."

    fs::ensure_directory "$XDG_CONFIG_HOME/theme"

    local src="$base_dir/modules/theme-base/src"

    fs::force_link "$src/carbon-dark.yaml"  "$XDG_CONFIG_HOME/theme/carbon-dark.yaml"
    fs::force_link "$src/carbon-light.yaml" "$XDG_CONFIG_HOME/theme/carbon-light.yaml"
    fs::force_link "$src/cursor.yaml"       "$XDG_CONFIG_HOME/theme/cursor.yaml"
    fs::force_link "$src/fonts.yaml"        "$XDG_CONFIG_HOME/theme/fonts.yaml"

    # Keep the scheme selected by `theme switch`; default to dark.
    if [[ ! -e "$XDG_CONFIG_HOME/theme/colors.yaml" ]]; then
        fs::force_link "$XDG_CONFIG_HOME/theme/carbon-dark.yaml" "$XDG_CONFIG_HOME/theme/colors.yaml"
    fi

    if [[ -f "$src/hosts/$DEPLOY_HOST.yaml" ]]; then
        fs::force_link "$src/hosts/$DEPLOY_HOST.yaml" "$XDG_CONFIG_HOME/theme/host.yaml"
    else
        rm -f "$XDG_CONFIG_HOME/theme/host.yaml"
    fi

    python3 "$XDG_OPT_HOME/theme/theme.py" parse

    template::render_mako "$src/dircolors.mako" "$XDG_CONFIG_HOME/theme/dircolors"
    template::render_mako "$src/eza-colors.mako" "$XDG_CONFIG_HOME/theme/eza-colors"
    template::render_mako "$src/carbon.pygments.mako.theme" "$XDG_CONFIG_HOME/theme/carbon.pygments.theme"

    fs::ensure_directory "$XDG_CONFIG_HOME/theme/forgejo"
    template::render_mako "$src/carbon.forgejo.mako.css" "$XDG_CONFIG_HOME/theme/forgejo/theme-carbon-dark.css" carbon-dark
    template::render_mako "$src/carbon.forgejo.mako.css" "$XDG_CONFIG_HOME/theme/forgejo/theme-carbon-light.css" carbon-light
}

theme-base::uninstall () {
    echo "└> Uninstalling theme base configuration."

    fs::remove "$XDG_CONFIG_HOME/theme/carbon-dark.yaml"
    fs::remove "$XDG_CONFIG_HOME/theme/carbon-light.yaml"
    fs::remove "$XDG_CONFIG_HOME/theme/cursor.yaml"
    fs::remove "$XDG_CONFIG_HOME/theme/colors.yaml"
    fs::remove "$XDG_CONFIG_HOME/theme/fonts.yaml"
    fs::remove "$XDG_CONFIG_HOME/theme/host.yaml"

    fs::remove "$XDG_CACHE_HOME/theme/theme-data.lua"
    fs::remove "$XDG_CACHE_HOME/theme/theme-data.sh"
    fs::remove "$XDG_CACHE_HOME/theme/theme-data.fish"

    fs::remove "$XDG_CONFIG_HOME/theme/dircolors"
    fs::remove "$XDG_CONFIG_HOME/theme/eza-colors"
    fs::remove "$XDG_CONFIG_HOME/theme/carbon.pygments.theme"
    fs::remove "$XDG_CONFIG_HOME/theme/forgejo"
}
