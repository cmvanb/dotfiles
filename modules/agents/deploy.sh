#-------------------------------------------------------------------------------
# Deploy shared agent instructions
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


agents::install() {
    echo "└> Installing shared agent instructions."

    local src="$base_dir/modules/agents/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/agents"
    fs::force_link "$src/AGENTS.md" "$XDG_CONFIG_HOME/agents/AGENTS.md"

    fs::ensure_directory "$XDG_BIN_HOME"
    fs::force_link "$src/agent-skills.sh" "$XDG_BIN_HOME/agent-skills"

    echo "└> Installing agent skills."

    "$src/agent-skills.sh" sync
}

agents::uninstall() {
    echo "└> Uninstalling shared agent instructions."

    fs::remove "$XDG_CONFIG_HOME/agents/AGENTS.md"
    fs::remove "$XDG_BIN_HOME/agent-skills"

    echo "└> Uninstalling agent skills."

    fs::remove "$XDG_CONFIG_HOME/agents/skills"
    fs::remove "$XDG_DATA_HOME/agents/vendor"
}
