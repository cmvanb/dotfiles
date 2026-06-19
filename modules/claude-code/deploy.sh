#-------------------------------------------------------------------------------
# Deploy Claude Code configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


claude-code::install() {
    echo "└> Installing Claude Code configuration."

    local src="$base_dir/modules/claude-code/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/claude"
    fs::force_link "$src/settings.json"                  "$XDG_CONFIG_HOME/claude/settings.json"
    fs::force_link "$XDG_CONFIG_HOME/agents/AGENTS.md"   "$XDG_CONFIG_HOME/claude/CLAUDE.md"
    fs::force_link "$XDG_CONFIG_HOME/agents/skills"      "$XDG_CONFIG_HOME/claude/skills"
    fs::force_link "$src/bash/claude-code.sh"            "$XDG_CONFIG_HOME/bash/conf.d/claude-code.sh"
    fs::force_link "$src/fish/claude-code.fish"          "$XDG_CONFIG_HOME/fish/conf.d/claude-code.fish"
}

claude-code::uninstall() {
    echo "└> Uninstalling Claude Code configuration."

    rm "$XDG_CONFIG_HOME/claude/settings.json"
    rm "$XDG_CONFIG_HOME/claude/CLAUDE.md"
    rm "$XDG_CONFIG_HOME/claude/skills"
    rm -f "$XDG_CONFIG_HOME/bash/conf.d/claude-code.sh"
    rm -f "$XDG_CONFIG_HOME/fish/conf.d/claude-code.fish"
}
