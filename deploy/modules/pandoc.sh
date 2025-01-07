#-------------------------------------------------------------------------------
# Deploy pandoc configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


pandoc::install () {
    echo "└> Installing pandoc configuration."

    ensure_directory "$XDG_DATA_HOME/pandoc"
    force_link "$base_dir/config/pandoc/templates" "$XDG_DATA_HOME/pandoc/templates"
}

pandoc::uninstall () {
    echo "└> Uninstalling pandoc configuration."

    rm -r "$XDG_DATA_HOME/pandoc"
}
