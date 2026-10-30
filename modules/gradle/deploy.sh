#-------------------------------------------------------------------------------
# Deploy gradle configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


gradle::install () {
    echo "└> Installing gradle configuration."

    local src="$base_dir/modules/gradle/src"

    fs::force_link "$src/bash/gradle.sh"   "$XDG_CONFIG_HOME/bash/conf.d/gradle.sh"
    fs::force_link "$src/fish/gradle.fish" "$XDG_CONFIG_HOME/fish/conf.d/gradle.fish"
}

gradle::uninstall () {
    echo "└> Uninstalling gradle configuration."

    rm -f "$XDG_CONFIG_HOME/bash/conf.d/gradle.sh"
    rm -f "$XDG_CONFIG_HOME/fish/conf.d/gradle.fish"
}
