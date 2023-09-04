#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Install user-specific software packages
#-------------------------------------------------------------------------------

set -euo pipefail

if ! command -v curl &> /dev/null; then
    echo "[$(basename "$0")] ERROR: Missing dependency: curl"
    exit 1
fi

home_dir=$HOME

# Install user packages
#-------------------------------------------------------------------------------

echo "Installing user packages to \`$home_dir\`."

# Python version management
if [[ ! -d $PYENV_ROOT ]]; then
    curl https://pyenv.run | bash
else
    echo "Not installing pyenv to \`$PYENV_ROOT\`, directory already exists."
fi
