#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Show webcam video using ffplay
#-------------------------------------------------------------------------------

ffplay -fflags nobuffer -input_format mjpeg -video_size 1600x1200 /dev/video0 > /dev/null 2>&1 &
