#-------------------------------------------------------------------------------
# POSIX shell $PATH utilities
#-------------------------------------------------------------------------------

# Usage: indirect_expand PATH -> $PATH
indirect_expand () {
    env |sed -n "s/^$1=//p"
}

# Usage: path_remove /path/to/bin [PATH]
# E.g., to remove ~/bin from $PATH
#     path_remove ~/bin PATH
path_remove () {
    local IFS=':'
    local newpath
    local dir
    local var=${2:-PATH}
    # Bash has ${!var}, but this is not portable.
    for dir in `indirect_expand "$var"`; do
        IFS=''
        if [ "$dir" != "$1" ]; then
            newpath=$newpath:$dir
        fi
    done
    export ${var}=${newpath#:}
}

# Usage: path_prepend /path/to/bin [PATH]
# E.g., to prepend ~/bin to $PATH
#     path_prepend ~/bin PATH
path_prepend () {
    # if the path is already in the variable,
    # remove it so we can move it to the front
    path_remove "$1" "$2"
    #[ -d "${1}" ] || return
    local var="${2:-PATH}"
    local value=`indirect_expand "$var"`
    export ${var}="${1}${value:+:${value}}"
}

# Usage: path_array [PATH]
# E.g., to get an array of path components.
path_array () {
    local result=()
    local IFS=:

    for component in $1; do
        result+=("$component")
    done

    echo "${result[@]}"
}
