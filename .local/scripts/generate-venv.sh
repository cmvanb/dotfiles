#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Generate python virtual environment
#-------------------------------------------------------------------------------

set -euo pipefail

echo "Generating python virtual environment in \`{$PWD}\`."

python -m venv venv

# Configure direnv to activate venv automatically.
echo "activate_venv $PWD/venv" > "$PWD/.envrc"
