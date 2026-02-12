#-------------------------------------------------------------------------------
# Deploy fish configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/modules/lib-shell-utils/src/fs.sh"


fish::install () {
    echo "└> Installing fish configuration."

    local src="$base_dir/modules/fish/src"

    ensure_directory "$XDG_CONFIG_HOME/fish"
    force_link "$src/config.fish" "$XDG_CONFIG_HOME/fish/config.fish"
    force_link "$src/interactive.fish" "$XDG_CONFIG_HOME/fish/interactive.fish"
    force_link "$src/logout.fish" "$XDG_CONFIG_HOME/fish/logout.fish"
    esh "$src/env.fish~esh" > "$XDG_CONFIG_HOME/fish/env.fish"
    esh "$src/login.fish~esh" > "$XDG_CONFIG_HOME/fish/login.fish"
    ensure_directory "$XDG_CONFIG_HOME/fish/functions"
    force_link "$src/functions/expand-dot-to-double-dot.fish" "$XDG_CONFIG_HOME/fish/functions/expand-dot-to-double-dot.fish"
    force_link "$src/functions/fish_prompt.fish" "$XDG_CONFIG_HOME/fish/functions/fish_prompt.fish"
    force_link "$src/functions/fish_title.fish" "$XDG_CONFIG_HOME/fish/functions/fish_title.fish"
    force_link "$src/functions/fish_shared_aliases.fish" "$XDG_CONFIG_HOME/fish/functions/fish_shared_aliases.fish"
    force_link "$src/functions/fish_user_key_bindings.fish" "$XDG_CONFIG_HOME/fish/functions/fish_user_key_bindings.fish"
    force_link "$src/functions/renr.fish" "$XDG_CONFIG_HOME/fish/functions/renr.fish"
    force_link "$src/functions/suspend.fish" "$XDG_CONFIG_HOME/fish/functions/suspend.fish"
    esh "$src/functions/fish_deployed_aliases.fish~esh" > "$XDG_CONFIG_HOME/fish/functions/fish_deployed_aliases.fish"
    ensure_directory "$XDG_CONFIG_HOME/fish/conf.d"
    force_link "$src/conf.d/00-xdg-base-dirs.fish" "$XDG_CONFIG_HOME/fish/conf.d/00-xdg-base-dirs.fish"
    force_link "$src/conf.d/fnm.fish" "$XDG_CONFIG_HOME/fish/conf.d/fnm.fish"
    force_link "$src/conf.d/direnv.fish" "$XDG_CONFIG_HOME/fish/conf.d/direnv.fish"
    force_link "$src/conf.d/lf.fish" "$XDG_CONFIG_HOME/fish/conf.d/lf.fish"
    force_link "$src/conf.d/pnpm.fish" "$XDG_CONFIG_HOME/fish/conf.d/pnpm.fish"
    force_link "$src/conf.d/pyenv.fish" "$XDG_CONFIG_HOME/fish/conf.d/pyenv.fish"
    force_link "$src/conf.d/yazi.fish" "$XDG_CONFIG_HOME/fish/conf.d/yazi.fish"
    force_link "$src/conf.d/zoxide.fish" "$XDG_CONFIG_HOME/fish/conf.d/zoxide.fish"

}

fish::uninstall () {
    echo "└> Uninstalling fish configuration."

    rm -r "$XDG_CONFIG_HOME/fish"
}
