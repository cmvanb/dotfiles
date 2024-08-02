#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Install user-specific software packages
#-------------------------------------------------------------------------------

base_dir="$(realpath "$(dirname "$(realpath "$0")")/..")"

# Imports
#-------------------------------------------------------------------------------

source "$base_dir/.local/opt/shell-utils/debug.sh"

# Validation
#-------------------------------------------------------------------------------

assert_dependency curl

# Install user packages
#-------------------------------------------------------------------------------

home_dir=$HOME

echo "Installing user packages to \`$home_dir\`."

if [[ ! -d $PYENV_ROOT ]]; then
    curl https://pyenv.run | bash
else
    echo "Not installing pyenv to \`$PYENV_ROOT\`, directory already exists."
fi
