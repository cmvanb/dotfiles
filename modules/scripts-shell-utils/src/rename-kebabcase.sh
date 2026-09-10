#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Apply kebabcase formatting to a filename
#-------------------------------------------------------------------------------

set -euo pipefail

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"
# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/fs.sh"
# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/name-formatting.sh"

if [[ ! -e "$1" ]]; then
    debug::error "File or directory \`$1\` does not exist."
    exit 1
fi

src_dirname="$(dirname -- "$1")"
src_basename="$(basename -- "$1")"

# Leading dots mark a hidden entry and stay untouched.
src_stem="${src_basename#"${src_basename%%[!.]*}"}"
dst_basename="${src_basename%"$src_stem"}"

# Dots separate the name from its extensions, so kebabcase each part on its own.
while [[ "$src_stem" == *.* ]]; do
    dst_basename+="$(convert_to_kebab_case "${src_stem%%.*}")."
    src_stem="${src_stem#*.}"
done

dst_basename+="$(convert_to_kebab_case "$src_stem")"

if [[ "$src_dirname" == "." && "$1" != ./* ]]; then
    dst_name="$dst_basename"
else
    dst_name="$src_dirname/$dst_basename"
fi

if [[ "$1" == "$dst_name" ]]; then
    exit 0
fi

fs::happy_move "$1" "$dst_name"
echo "$1 -> $dst_name"
