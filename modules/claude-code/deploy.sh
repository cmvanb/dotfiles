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
    fs::force_link "$src/settings.json" "$XDG_CONFIG_HOME/claude/settings.json"
    fs::force_link "$src/CLAUDE.md"     "$XDG_CONFIG_HOME/claude/CLAUDE.md"
}

claude-code::uninstall() {
    echo "└> Uninstalling Claude Code configuration."

    rm "$XDG_CONFIG_HOME/claude/settings.json"
    rm "$XDG_CONFIG_HOME/claude/CLAUDE.md"
}
