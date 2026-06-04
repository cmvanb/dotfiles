#-------------------------------------------------------------------------------
# Deploy docker configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


docker::install () {
    echo "└> Installing docker configuration."

    local src="$base_dir/modules/docker/src"

    fs::force_link "$src/bash/docker.sh"   "$XDG_CONFIG_HOME/bash/conf.d/docker.sh"
    fs::force_link "$src/fish/docker.fish" "$XDG_CONFIG_HOME/fish/conf.d/docker.fish"
}

docker::uninstall () {
    echo "└> Uninstalling docker configuration."

    rm -f "$XDG_CONFIG_HOME/bash/conf.d/docker.sh"
    rm -f "$XDG_CONFIG_HOME/fish/conf.d/docker.fish"
}
