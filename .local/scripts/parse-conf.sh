#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Parse a `NAME=VALUE` configuration file to an associative array.
#
# Usage:
# ```
# local -n result=conf_vars
# echo "${result[CONF_VARNAME]}"
# ```
#-------------------------------------------------------------------------------

set -euo pipefail

declare -A conf_vars

parse_conf () {
    conf_file=$1

    if [[ -z "$conf_file" ]]; then
        echo "[$(basename "$0")] ERROR: Missing argument: configuration filename"
        exit 1
    fi

    if [[ ! -f "$conf_file" ]]; then
        echo "[$(basename "$0")] ERROR: \`$1\` does not exist."
        exit 1
    fi

    while IFS='= ' read -r lhs rhs
    do
        if [[ ! $lhs =~ ^\ *# && -n $lhs ]]; then
            # Remove trailing comments.
            rhs="${rhs%%\#*}"

            # Remove trailing spaces.
            rhs="$(echo "$rhs" | xargs)"

            # Remove opening string quotes.
            rhs="${rhs%\"*}"

            # Remove closing string quotes.
            rhs="${rhs#\"*}"

            conf_vars[$lhs]="$rhs"
        fi
    done < "$conf_file"

    export conf_vars
}
