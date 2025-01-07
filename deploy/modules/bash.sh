#-------------------------------------------------------------------------------
# Deploy bash configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


bash::install () {
    echo "└> Installing bash configuration."

    mkdir -p "$XDG_CONFIG_HOME/bash"
    force_link "$base_dir/config/bash/bash_profile" "$XDG_CONFIG_HOME/bash/bash_profile"
    force_link "$base_dir/config/bash/bashrc" "$XDG_CONFIG_HOME/bash/bashrc"
    esh "$base_dir/config/bash/env.sh~esh" > "$XDG_CONFIG_HOME/bash/env.sh"
    esh "$base_dir/config/bash/interactive.sh~esh" > "$XDG_CONFIG_HOME/bash/interactive.sh"
    esh "$base_dir/config/bash/login.sh~esh" > "$XDG_CONFIG_HOME/bash/login.sh"
    force_link "$base_dir/config/bash/logout.sh" "$XDG_CONFIG_HOME/bash/logout.sh"
    force_link "$base_dir/config/bash/prompt.sh" "$XDG_CONFIG_HOME/bash/prompt.sh"
}

bash::uninstall () {
    echo "└> Uninstalling bash configuration."

    rm -rf "$XDG_CONFIG_HOME/bash"
}
