#-------------------------------------------------------------------------------
# Deploy dotnet configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


dotnet::install () {
    echo "└> Installing dotnet configuration."

    local src="$base_dir/modules/dotnet/src"

    fs::force_link "$src/bash/dotnet.sh"   "$XDG_CONFIG_HOME/bash/conf.d/dotnet.sh"
    fs::force_link "$src/fish/dotnet.fish" "$XDG_CONFIG_HOME/fish/conf.d/dotnet.fish"
}

dotnet::uninstall () {
    echo "└> Uninstalling dotnet configuration."

    rm -f "$XDG_CONFIG_HOME/bash/conf.d/dotnet.sh"
    rm -f "$XDG_CONFIG_HOME/fish/conf.d/dotnet.fish"
}
