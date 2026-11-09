#-------------------------------------------------------------------------------
# Deploy pi configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


pi::install () {
    echo "└> Installing pi configuration."

    local src="$base_dir/modules/pi/src"

    fs::force_link "$src/bash/pi.sh"   "$XDG_CONFIG_HOME/bash/conf.d/pi.sh"
    fs::force_link "$src/fish/pi.fish" "$XDG_CONFIG_HOME/fish/conf.d/pi.fish"

    fs::ensure_directory "$XDG_CONFIG_HOME/pi/themes"
    fs::ensure_directory "$XDG_CONFIG_HOME/pi/extensions"
    fs::force_link "$src/settings.json" "$XDG_CONFIG_HOME/pi/settings.json"
    fs::force_link "$src/extensions/block-env.ts" "$XDG_CONFIG_HOME/pi/extensions/block-env.ts"
    fs::force_link "$XDG_CONFIG_HOME/agents/AGENTS.md" "$XDG_CONFIG_HOME/pi/AGENTS.md"
    fs::force_link "$XDG_CONFIG_HOME/agents/skills"    "$XDG_CONFIG_HOME/pi/skills"
    template::render_mako "$src/themes/carbon.mako.json" "$XDG_CONFIG_HOME/pi/themes/carbon.json"
}

pi::uninstall () {
    echo "└> Uninstalling pi configuration."

    fs::remove "$XDG_CONFIG_HOME/bash/conf.d/pi.sh"
    fs::remove "$XDG_CONFIG_HOME/fish/conf.d/pi.fish"
    fs::remove "$XDG_CONFIG_HOME/pi/settings.json"
    fs::remove "$XDG_CONFIG_HOME/pi/extensions/block-env.ts"
    fs::remove "$XDG_CONFIG_HOME/pi/AGENTS.md"
    fs::remove "$XDG_CONFIG_HOME/pi/skills"
    fs::remove "$XDG_CONFIG_HOME/pi/themes/carbon.json"
}
