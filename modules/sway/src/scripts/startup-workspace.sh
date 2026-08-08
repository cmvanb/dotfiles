#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Sway workspace startup
#
# Opens startup workspaces and focuses workspace 1. Exec'd by sway at startup.
#-------------------------------------------------------------------------------

swaymsg 'workspace 11:home; exec bash -c "nm-online -qs && sleep 1 && qutebrowser -r home"'
swaymsg 'workspace 13:todo; exec spawn-terminal.sh --working-directory ~/Wiki/todo --command edit'
swaymsg 'workspace 15:auth; exec Bitwarden'
swaymsg 'workspace 12:mail; exec geary'
swaymsg workspace 1
