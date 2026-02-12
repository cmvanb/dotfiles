#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Follow the white rabbit.
#-------------------------------------------------------------------------------

set -euo pipefail

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

assert_dependency neo-matrix

neo-matrix \
    --charset punc \
    --defaultbg \
    --fps 16 \
    --glitchpct 1.0 \
