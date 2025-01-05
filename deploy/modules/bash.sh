#-------------------------------------------------------------------------------
# Deploy bash configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

source "$base_dir/local/opt/shell-utils/fs.sh"


bash::install () {
    echo "└> Installing bash configuration."

    mkdir -p "$config_dir/bash"
    force_link "$base_dir/config/bash/bash_profile" "$config_dir/bash/bash_profile"
    force_link "$base_dir/config/bash/bashrc" "$config_dir/bash/bashrc"
    esh "$base_dir/config/bash/env.sh~esh" > "$config_dir/bash/env.sh"
    esh "$base_dir/config/bash/interactive.sh~esh" > "$config_dir/bash/interactive.sh"
    esh "$base_dir/config/bash/login.sh~esh" > "$config_dir/bash/login.sh"
    force_link "$base_dir/config/bash/logout.sh" "$config_dir/bash/logout.sh"
    force_link "$base_dir/config/bash/prompt.sh" "$config_dir/bash/prompt.sh"
}

bash::uninstall () {
    echo "└> Uninstalling bash configuration."

    rm -rf "$config_dir/bash"
}
