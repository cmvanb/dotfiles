#-------------------------------------------------------------------------------
# Deploy ansible configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


ansible::install () {
    echo "└> Installing ansible configuration."

    local src="$base_dir/modules/ansible/src"

    fs::force_link "$src/bash/ansible.sh"   "$XDG_CONFIG_HOME/bash/conf.d/ansible.sh"
    fs::force_link "$src/fish/ansible.fish" "$XDG_CONFIG_HOME/fish/conf.d/ansible.fish"
}

ansible::uninstall () {
    echo "└> Uninstalling ansible configuration."

    rm -f "$XDG_CONFIG_HOME/bash/conf.d/ansible.sh"
    rm -f "$XDG_CONFIG_HOME/fish/conf.d/ansible.fish"
}
