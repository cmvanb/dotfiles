#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Open qutebrowser in a new window
#
# Target for $BROWSER. Programs such as Claude Code run `$BROWSER <url>`, which
# otherwise opens a tab in the last focused window, on any workspace. Later
# arguments override --target, so `--target private-window` still works.
#-------------------------------------------------------------------------------

exec qutebrowser --target window "$@"
