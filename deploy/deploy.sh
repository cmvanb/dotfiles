#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy the dotfiles
#-------------------------------------------------------------------------------

set -euo pipefail

bash_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source_dir=$( realpath "$bash_dir/.." )
home_dir=$HOME

echo "Deploying dotfiles from \`$source_dir\` to \`$home_dir\`..."

source $bash_dir/link-dotfiles.sh
source $bash_dir/generate-dotfiles-templates.sh
source $bash_dir/apply-host-configuration.sh
source $bash_dir/enable-systemd-services.sh

echo "...deployment complete."
