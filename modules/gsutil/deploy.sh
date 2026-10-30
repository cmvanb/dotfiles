#-------------------------------------------------------------------------------
# Deploy gsutil configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


gsutil::install () {
    echo "└> Installing gsutil configuration."

    local src="$base_dir/modules/gsutil/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/boto"
    template::render_mako "$src/boto.mako" "$XDG_CONFIG_HOME/boto/config"

    fs::force_link "$src/bash/gsutil.sh"   "$XDG_CONFIG_HOME/bash/conf.d/gsutil.sh"
    fs::force_link "$src/fish/gsutil.fish" "$XDG_CONFIG_HOME/fish/conf.d/gsutil.fish"
}

gsutil::uninstall () {
    echo "└> Uninstalling gsutil configuration."

    rm -r "$XDG_CONFIG_HOME/boto"
    rm -f "$XDG_CONFIG_HOME/bash/conf.d/gsutil.sh"
    rm -f "$XDG_CONFIG_HOME/fish/conf.d/gsutil.fish"
}
