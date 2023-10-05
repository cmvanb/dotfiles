#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Select an existing bookmark
#-------------------------------------------------------------------------------

set -euo pipefail

# Imports
#-------------------------------------------------------------------------------

source $XDG_SCRIPTS_HOME/debug-utils.sh

# Validation
#-------------------------------------------------------------------------------

assert_dependency wofi

# Select a bookmark
#-------------------------------------------------------------------------------

bookmarks_dir=$HOME/Wiki/bookmarks

bookmarks=$(fd . "$bookmarks_dir" --max-depth 1 --exec basename)

# TODO: Use bookmark title from YAML frontmatter instead of file name.
# NOTE: Performance of `yq` in this loop is seriously degraded compared to
# being run in bare shell. Needs investigation. `awk` performance is no better.
# i=0
# for b in $bookmarks; do
#     (( i=i+1 ))
#     # see: https://github.com/kislyuk/yq/issues/151
#     # bookmark_title=$(awk '{ if ($1 == "---" || $1 == "...") n+=1; if(n>1) exit 0; print; }' $b | yq -Mr -- ".aliases[]")
#     bookmark_title=$(yq -Mr -- ".aliases[]" $b 2> /dev/null)
#     echo "$i: $bookmark_title"
# done

bookmark=$(echo "$bookmarks" | wofi --prompt "Open bookmark" --show dmenu 2> /dev/null)

bookmark_file="$bookmarks_dir/$bookmark"

url=$(rg --only-matching --no-line-number "\(([^}]*)\)" $bookmark_file)
url=${url:1:-1}

qutebrowser --target window --untrusted-args $url 2> /dev/null
