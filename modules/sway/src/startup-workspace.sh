#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Sway workspace startup
#
# Opens startup workspaces and focuses workspace 1. Exec'd by sway at startup.
#-------------------------------------------------------------------------------

swaymsg 'workspace todo; exec spawn-terminal.sh --working-directory ~/Wiki/todo --command edit'
swaymsg 'workspace home; exec qutebrowser -r home'
swaymsg workspace 1
