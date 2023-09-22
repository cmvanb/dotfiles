#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Install user-specific software packages
#-------------------------------------------------------------------------------

set -euo pipefail

# Imports
#-------------------------------------------------------------------------------

source "$source_dir/.local/scripts/debug-utils.sh"

# Validation
#-------------------------------------------------------------------------------

assert_dependency curl

# Install user packages
#-------------------------------------------------------------------------------

home_dir=$HOME

echo "Installing user packages to \`$home_dir\`."

# Python version management
if [[ ! -d $PYENV_ROOT ]]; then
    curl https://pyenv.run | bash
else
    echo "Not installing pyenv to \`$PYENV_ROOT\`, directory already exists."
fi
