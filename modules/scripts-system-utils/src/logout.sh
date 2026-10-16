#!/usr/bin/env bash

# NOTE: The path variable is not overriding the shell builtin in bash, so it
# can't be invoked with `logout` in bash.

# Stop graphical services while the compositor still runs, so they exit cleanly
# instead of crashing on a lost display connection.
session_type=$(loginctl show-session "$XDG_SESSION_ID" --property=Type --value)
if [[ $session_type == wayland || $session_type == x11 ]]; then
    systemctl --user stop '*-session.target'
fi

loginctl kill-session "$XDG_SESSION_ID"
