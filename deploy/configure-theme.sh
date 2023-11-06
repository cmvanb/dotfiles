#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy the theme configuration
#-------------------------------------------------------------------------------

set -euo pipefail

bash_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
source_dir=$(realpath "$bash_dir/..")

echo "Configuring theme."

# Configure GTK
#-------------------------------------------------------------------------------

source "$source_dir/.config/theme/configure-gtk.sh"

# Re-build bat cache
#-------------------------------------------------------------------------------

/usr/bin/bat cache --build
