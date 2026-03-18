#-------------------------------------------------------------------------------
# Deploy bash configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


bash::install () {
    echo "└> Installing bash configuration."

    local src="$base_dir/modules/bash/src"

    ensure_directory "$XDG_CONFIG_HOME/bash"
    force_link "$src/bash_profile" "$XDG_CONFIG_HOME/bash/bash_profile"
    force_link "$src/bashrc" "$XDG_CONFIG_HOME/bash/bashrc"
    render_esh_template "$src/env.esh.sh" "$XDG_CONFIG_HOME/bash/env.sh"
    render_esh_template "$src/interactive.esh.sh" "$XDG_CONFIG_HOME/bash/interactive.sh"
    force_link "$src/shared_aliases.sh" "$XDG_CONFIG_HOME/bash/shared_aliases.sh"
    render_esh_template "$src/deployed_aliases.esh.sh" "$XDG_CONFIG_HOME/bash/deployed_aliases.sh"
    render_esh_template "$src/login.esh.sh" "$XDG_CONFIG_HOME/bash/login.sh"
    force_link "$src/logout.sh" "$XDG_CONFIG_HOME/bash/logout.sh"
    force_link "$src/prompt.sh" "$XDG_CONFIG_HOME/bash/prompt.sh"
}

bash::uninstall () {
    echo "└> Uninstalling bash configuration."

    rm -rf "$XDG_CONFIG_HOME/bash"
}
