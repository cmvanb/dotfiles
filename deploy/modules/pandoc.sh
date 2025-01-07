#-------------------------------------------------------------------------------
# Deploy pandoc configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


pandoc::install () {
    echo "└> Installing pandoc configuration."

    force_link "$base_dir/local/share/pandoc" "$XDG_DATA_HOME/pandoc"
}

pandoc::uninstall () {
    echo "└> Uninstalling pandoc configuration."

    rm "$XDG_DATA_HOME/pandoc"
}
