#!/bin/bash

INKSCAPE="/usr/bin/inkscape"
OPTIPNG="/usr/bin/optipng"

INDEX="backgrounds.txt"
SRC_FILE="backgrounds.svg"

if [[ "$1" == "1080p" ]]; then
  BACKGROUNDS_DIR="1080p"
  EXPORT_DPI="96"
elif [[ "$1" == "2k" ]]; then
  BACKGROUNDS_DIR="2k"
  EXPORT_DPI="144"
elif [[ "$1" == "4k" ]]; then
  BACKGROUNDS_DIR="4k"
  EXPORT_DPI="192"
else
  echo "Please use either '1080p', '2k' or '4k'"
  exit 1
fi

install -d "$BACKGROUNDS_DIR"

while read -r i; do
  if [[ -f "$BACKGROUNDS_DIR/$i.png" ]]; then
    echo "$BACKGROUNDS_DIR/$i.png exists"
  elif [[ "$i" == "" ]]; then
    continue
  else
    echo -e "\nRendering $BACKGROUNDS_DIR/$i.png"
    $INKSCAPE "--export-id=$i" \
              "--export-dpi=$EXPORT_DPI" \
              "--export-id-only" \
              "--export-filename=$BACKGROUNDS_DIR/$i.png" "$SRC_FILE" >/dev/null
    $OPTIPNG -strip all -nc "$BACKGROUNDS_DIR/$i.png"
  fi
done < "$INDEX"

exit 0
