#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Launch an application by its desktop file id (the .desktop filename minus
# the extension), searching XDG_DATA_HOME then XDG_DATA_DIRS — the standard
# lookup order for application desktop files. No GTK dependency.
#-------------------------------------------------------------------------------

set -euo pipefail

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

debug::assert_dependency dex

if [[ $# -ne 1 ]]; then
    echo "$(basename "$0") <desktop-id>"
    exit 1
fi

id="$1"

IFS=':' read -ra data_dirs <<< "${XDG_DATA_HOME:-$HOME/.local/share}:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"

for dir in "${data_dirs[@]}"; do
    file="$dir/applications/$id.desktop"
    if [[ -f $file ]]; then
        exec dex "$file"
    fi
done

debug::error_notify "No desktop file found for '$id'"
exit 1
