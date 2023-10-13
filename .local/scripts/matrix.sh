#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Follow the white rabbit.
#-------------------------------------------------------------------------------

set -euo pipefail

source $XDG_SCRIPTS_HOME/debug-utils.sh

assert_dependency neo-matrix

neo-matrix \
    --charset punc \
    --defaultbg \
    --fps 16 \
    --glitchpct 1.0 \
