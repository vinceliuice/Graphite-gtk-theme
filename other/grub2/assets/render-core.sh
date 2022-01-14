#!/bin/bash

INKSCAPE="/usr/bin/inkscape"
OPTIPNG="/usr/bin/optipng"

if [[ "$1" == "assets" ]]; then
  INDEX="assets.txt"
  SRC_FILE="assets$2.svg"
else
  INDEX="logos.txt"
  SRC_FILE="logos$2.svg"
fi

if [[ "$3" == "1080p" ]]; then
  ASSETS_DIR="$1$2/1080p"
  EXPORT_DPI="96"
elif [[ "$3" == "2k" ]]; then
  ASSETS_DIR="$1$2/2k"
  EXPORT_DPI="144"
elif [[ "$3" == "4k" ]]; then
  ASSETS_DIR="$1$2/4k"
  EXPORT_DPI="192"
else
  echo "Please use either '1080p', '2k' or '4k'"
  exit 1
fi

install -d "$ASSETS_DIR"

while read -r i; do
  if [[ -f "$ASSETS_DIR/$i.png" ]]; then
    echo "$ASSETS_DIR/$i.png exists"
  elif [[ "$i" == "" ]]; then
    continue
  else
    echo -e "\nRendering $ASSETS_DIR/$i.png"
    $INKSCAPE "--export-id=$i" \
              "--export-dpi=$EXPORT_DPI" \
              "--export-id-only" \
              "--export-filename=$ASSETS_DIR/$i.png" "$SRC_FILE" >/dev/null
    $OPTIPNG -strip all -nc "$ASSETS_DIR/$i.png"
  fi
done < "$INDEX"

if [[ "$1" == "logos" ]]; then
  cd "$ASSETS_DIR" || exit 1
  cp -a archlinux.png arch.png
  cp -a gnu-linux.png linux.png
  cp -a gnu-linux.png unknown.png
  cp -a gnu-linux.png lfs.png
  cp -a manjaro.png Manjaro.i686.png
  cp -a manjaro.png Manjaro.x86_64.png
  cp -a manjaro.png manjarolinux.png
  cp -a pop-os.png pop.png
  cp -a driver.png memtest.png
fi
exit 0
