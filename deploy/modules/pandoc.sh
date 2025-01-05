#-------------------------------------------------------------------------------
# Deploy pandoc configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
data_dir=${XDG_DATA_HOME:-$HOME/.local/share}

source "$base_dir/local/opt/shell-utils/fs.sh"


pandoc::install () {
    echo "└> Installing pandoc configuration."

    force_link "$base_dir/local/share/pandoc" "$data_dir/pandoc"
}

pandoc::uninstall () {
    echo "└> Uninstalling pandoc configuration."

    rm "$data_dir/pandoc"
}
