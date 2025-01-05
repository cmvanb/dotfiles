#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy desktop configuration files
#-------------------------------------------------------------------------------

# Setup
#-------------------------------------------------------------------------------

data_dir=${XDG_DATA_HOME:-$HOME/.local/share}
templates_dir=${XDG_TEMPLATES_DIR:-$data_dir/templates}

source "$base_dir/local/opt/shell-utils/debug.sh"

assert_dependency esh

# Link shared data
#-------------------------------------------------------------------------------

# Templates
mkdir -p "$templates_dir"
force_link "$base_dir/local/share/templates/bookmark.md~esh" "$templates_dir/bookmark.md~esh"
