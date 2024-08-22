#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy desktop user packages
#-------------------------------------------------------------------------------

echo "Deploying desktop user packages..."

# Setup
#-------------------------------------------------------------------------------

source "$base_dir/.local/opt/shell-utils/debug.sh"

assert_dependency curl

# Install user packages
#-------------------------------------------------------------------------------

if [[ ! -d $PYENV_ROOT ]]; then
    echo "└ Installing pyenv to \`$PYENV_ROOT\`."
    curl https://pyenv.run | bash

else
    echo "└ Not installing pyenv to \`$PYENV_ROOT\`; directory already exists."

fi
