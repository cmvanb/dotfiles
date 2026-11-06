#-------------------------------------------------------------------------------
# Deploy opencode configuration
#-------------------------------------------------------------------------------

script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"

opencode::install () {
    echo "└> Installing opencode configuration."

    local src="$base_dir/modules/opencode/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/opencode"
    fs::force_link "$src/opencode.json"                 "$XDG_CONFIG_HOME/opencode/opencode.json"
    fs::force_link "$src/tui.json"                      "$XDG_CONFIG_HOME/opencode/tui.json"
    fs::force_link "$XDG_CONFIG_HOME/agents/AGENTS.md"  "$XDG_CONFIG_HOME/opencode/AGENTS.md"
    fs::force_link "$XDG_CONFIG_HOME/agents/skills"     "$XDG_CONFIG_HOME/opencode/skills"
    fs::force_link "$src/plugins"                       "$XDG_CONFIG_HOME/opencode/plugins"

    fs::ensure_directory "$XDG_CONFIG_HOME/opencode/themes"
    template::render_mako "$src/themes/carbon.mako.json" "$XDG_CONFIG_HOME/opencode/themes/carbon.json"
}

opencode::uninstall () {
    echo "└> Uninstalling opencode configuration."

    fs::remove "$XDG_CONFIG_HOME/opencode/opencode.json"
    fs::remove "$XDG_CONFIG_HOME/opencode/tui.json"
    fs::remove "$XDG_CONFIG_HOME/opencode/AGENTS.md"
    fs::remove "$XDG_CONFIG_HOME/opencode/skills"
    fs::remove "$XDG_CONFIG_HOME/opencode/plugins"
    fs::remove "$XDG_CONFIG_HOME/opencode/themes/carbon.json"
}
