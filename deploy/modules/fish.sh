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
    force_link "$base_dir/config/fish/interactive.fish" "$XDG_CONFIG_HOME/fish/interactive.fish"
    force_link "$base_dir/config/fish/logout.fish" "$XDG_CONFIG_HOME/fish/logout.fish"
    esh "$base_dir/config/fish/env.fish~esh" > "$XDG_CONFIG_HOME/fish/env.fish"
    esh "$base_dir/config/fish/login.fish~esh" > "$XDG_CONFIG_HOME/fish/login.fish"
    ensure_directory "$XDG_CONFIG_HOME/fish/functions"
    force_link "$base_dir/config/fish/functions/expand-dot-to-double-dot.fish" "$XDG_CONFIG_HOME/fish/functions/expand-dot-to-double-dot.fish"
    force_link "$base_dir/config/fish/functions/fish_prompt.fish" "$XDG_CONFIG_HOME/fish/functions/fish_prompt.fish"
    force_link "$base_dir/config/fish/functions/fish_title.fish" "$XDG_CONFIG_HOME/fish/functions/fish_title.fish"
    force_link "$base_dir/config/fish/functions/fish_shared_aliases.fish" "$XDG_CONFIG_HOME/fish/functions/fish_shared_aliases.fish"
    force_link "$base_dir/config/fish/functions/fish_user_key_bindings.fish" "$XDG_CONFIG_HOME/fish/functions/fish_user_key_bindings.fish"
    force_link "$base_dir/config/fish/functions/renr.fish" "$XDG_CONFIG_HOME/fish/functions/renr.fish"
    force_link "$base_dir/config/fish/functions/suspend.fish" "$XDG_CONFIG_HOME/fish/functions/suspend.fish"
    esh "$base_dir/config/fish/functions/fish_deployed_aliases.fish~esh" > "$XDG_CONFIG_HOME/fish/functions/fish_deployed_aliases.fish"
    ensure_directory "$XDG_CONFIG_HOME/fish/conf.d"
    force_link "$base_dir/config/fish/conf.d/fnm.fish" "$XDG_CONFIG_HOME/fish/conf.d/fnm.fish"
    force_link "$base_dir/config/fish/conf.d/direnv.fish" "$XDG_CONFIG_HOME/fish/conf.d/direnv.fish"
    force_link "$base_dir/config/fish/conf.d/lf.fish" "$XDG_CONFIG_HOME/fish/conf.d/lf.fish"
    force_link "$base_dir/config/fish/conf.d/pnpm.fish" "$XDG_CONFIG_HOME/fish/conf.d/pnpm.fish"
    force_link "$base_dir/config/fish/conf.d/yazi.fish" "$XDG_CONFIG_HOME/fish/conf.d/yazi.fish"
    force_link "$base_dir/config/fish/conf.d/zoxide.fish" "$XDG_CONFIG_HOME/fish/conf.d/zoxide.fish"

}

fish::uninstall () {
    echo "└> Uninstalling fish configuration."

    rm -r "$XDG_CONFIG_HOME/fish"
}
