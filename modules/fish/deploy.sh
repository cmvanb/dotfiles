#-------------------------------------------------------------------------------
# Deploy fish configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


fish::install () {
    echo "└> Installing fish configuration."

    local src="$base_dir/modules/fish/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/fish"
    fs::force_link "$src/config.fish" "$XDG_CONFIG_HOME/fish/config.fish"
    fs::force_link "$src/interactive.fish" "$XDG_CONFIG_HOME/fish/interactive.fish"
    fs::force_link "$src/logout.fish" "$XDG_CONFIG_HOME/fish/logout.fish"
    template::render_mako "$src/env.mako.fish" "$XDG_CONFIG_HOME/fish/env.fish"
    template::render_mako "$src/login.mako.fish" "$XDG_CONFIG_HOME/fish/login.fish"
    fs::ensure_directory "$XDG_CONFIG_HOME/fish/functions"
    fs::force_link "$src/functions/expand-dot-to-double-dot.fish" "$XDG_CONFIG_HOME/fish/functions/expand-dot-to-double-dot.fish"
    fs::force_link "$src/functions/fish_prompt.fish" "$XDG_CONFIG_HOME/fish/functions/fish_prompt.fish"
    fs::force_link "$src/functions/fish_title.fish" "$XDG_CONFIG_HOME/fish/functions/fish_title.fish"
    fs::force_link "$src/functions/fish_shared_aliases.fish" "$XDG_CONFIG_HOME/fish/functions/fish_shared_aliases.fish"
    fs::force_link "$src/functions/fish_user_key_bindings.fish" "$XDG_CONFIG_HOME/fish/functions/fish_user_key_bindings.fish"
    fs::force_link "$src/functions/renr.fish" "$XDG_CONFIG_HOME/fish/functions/renr.fish"
    fs::force_link "$src/functions/suspend.fish" "$XDG_CONFIG_HOME/fish/functions/suspend.fish"
    template::render_mako "$src/functions/fish_deployed_aliases.mako.fish" "$XDG_CONFIG_HOME/fish/functions/fish_deployed_aliases.fish"
    fs::ensure_directory "$XDG_CONFIG_HOME/fish/conf.d"
    fs::force_link "$src/conf.d/00-xdg-base-dirs.fish" "$XDG_CONFIG_HOME/fish/conf.d/00-xdg-base-dirs.fish"
    fs::force_link "$src/conf.d/fnm.fish" "$XDG_CONFIG_HOME/fish/conf.d/fnm.fish"
    fs::force_link "$src/conf.d/direnv.fish" "$XDG_CONFIG_HOME/fish/conf.d/direnv.fish"
    fs::force_link "$src/conf.d/pnpm.fish" "$XDG_CONFIG_HOME/fish/conf.d/pnpm.fish"
    fs::force_link "$src/conf.d/pyenv.fish" "$XDG_CONFIG_HOME/fish/conf.d/pyenv.fish"
    fs::force_link "$src/conf.d/yazi.fish" "$XDG_CONFIG_HOME/fish/conf.d/yazi.fish"
    fs::force_link "$src/conf.d/zoxide.fish" "$XDG_CONFIG_HOME/fish/conf.d/zoxide.fish"

}

fish::uninstall () {
    echo "└> Uninstalling fish configuration."

    rm -r "$XDG_CONFIG_HOME/fish"
}
