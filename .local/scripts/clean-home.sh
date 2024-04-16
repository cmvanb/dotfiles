#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Clean the home directory of various XDG offenders
#-------------------------------------------------------------------------------

set -euo pipefail

declare -a dirs=(
    ".cache"
    ".cert"
    ".k3d"
    ".kube"
    ".java"
    ".pki"
    ".qne"
    ".terraform.d"
)

for dir in "${dirs[@]}"; do
    if [[ -d ~/"$dir" ]]; then
        rm -rf "${HOME:?}/$dir"
    fi
done
