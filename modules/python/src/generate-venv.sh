#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Generate python virtual environment
#-------------------------------------------------------------------------------

set -euo pipefail

echo "Generating python virtual environment in \`{$PWD}\`."

python -m venv .venv

# Configure mise to activate venv automatically.
printf '[env]\n_.python.venv = ".venv"\n' > "$PWD/mise.local.toml"
