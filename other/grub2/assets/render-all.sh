#!/bin/bash

THEMES=("logos" "assets")
COLORS=("" "-nord")
RESOLUTIONS=("1080p" "2k" "4k")

for theme in "${THEMES[@]}"; do
  for color in "${COLORS[@]}"; do
    for resolution in "${RESOLUTIONS[@]}"; do
      echo "./render-core.sh \"$theme\" \"$color\" \"$resolution\": "
      ./render-core.sh "$theme" "$color" "$resolution"
    done
  done
done

exit 0
