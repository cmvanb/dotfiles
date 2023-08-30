#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Follow the white rabbit.
#-------------------------------------------------------------------------------

set -euo pipefail

if ! command -v fortune &> /dev/null; then
    exit 42
fi
if ! command -v neo-matrix &> /dev/null; then
    exit 69
fi

message=$(fortune -n 140 -s)

neo-matrix \
    --charset cyrillic \
    --defaultbg \
    --fps 30 \
    --message "$message"
