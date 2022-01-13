#!/bin/bash

RESOLUTIONS=("1080p" "2k" "4k" "3200x2000")

for resolution in "${RESOLUTIONS[@]}"; do
  echo "./render-core.sh \"$resolution\": "
  ./render-core.sh "$resolution"
done

exit 0
