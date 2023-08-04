# Ensure ~/.config/shell/bash/env gets run first
. ~/.config/shell/bash/env

# Prevent it from being run later, since we need to use $BASH_ENV for
# non-login non-interactive shells.
# We don't export it, as we may have a non-login non-interactive shell as
# a child.
unset BASH_ENV

# Run ~/.bash/login
. ~/.config/shell/bash/login

# Run ~/.bash/interactive if this is an interactive shell.
if [ "$PS1" ]; then
    . ~/.config/shell/bash/interactive
fi

