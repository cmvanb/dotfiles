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
    ".npm"
    ".pki"
    ".qne"
    ".terraform.d"
    ".yarn"
)

declare -a files=(
    ".lesshst"
    ".viminfo"
    ".yarnrc"
)

# Remove directories.
for dir in "${dirs[@]}"; do
    if [[ -d "$HOME/$dir" ]]; then
        rm -rf "${HOME:?}/$dir"
    fi
done

# Remove files.
for file in "${files[@]}"; do
    if [[ -f "$HOME/$file" ]]; then
        rm -f "${HOME:?}/$file"
    fi
done
