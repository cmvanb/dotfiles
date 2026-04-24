#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Sway workspace startup
#
# Opens startup workspaces and focuses workspace 1. Exec'd by sway at startup.
#-------------------------------------------------------------------------------

swaymsg 'workspace home; exec bash -c "nm-online -qs && sleep 1 && qutebrowser -r home"'
swaymsg 'workspace todo; exec spawn-terminal.sh --working-directory ~/Wiki/todo --command edit'
swaymsg 'workspace auth; exec Bitwarden'
swaymsg 'workspace mail; exec geary'
swaymsg workspace 1
