#!/bin/bash

INKSCAPE="$(command -v inkscape)" || true
OPTIPNG="$(command -v optipng)" || true
CONVERT="$(command -v convert)" || true

screen='4k'

if [[ "${screen}" == '1080p' ]]; then
  DPI="96"
elif [[ "${screen}" == '2k' ]]; then
  DPI="128"
elif [[ "${screen}" == '4k' ]]; then
  DPI="192"
fi

for color in '-Light' '-Dark'; do
for theme in '' '-nord'; do
for system in '' '-arch' '-debian' '-fedora' '-manjaro' '-ubuntu' '-pop-os'; do

FILE_ID="wave${color}${theme}${system}"
SRC_FILE="src/wallpaper-wave${theme}.svg"
PNG_file="wallpapers${theme}/$FILE_ID.png"
JPG_file="wallpapers${theme}/$FILE_ID.jpg"

if [[ -f "$JPG_file" ]]; then
  echo "'$JPG_file' exist! "
else
  echo "Rendering '$PNG_file'"
    "$INKSCAPE" --export-id="$FILE_ID" \
                --export-id-only \
                --export-dpi="$DPI" \
                --export-filename="$PNG_file" "$SRC_FILE" >/dev/null

#  if [[ -n "${OPTIPNG}" ]]; then
#    "$OPTIPNG" -o7 --quiet "$PNG_file"
#  fi

  echo "Rendering '$JPG_file'"
  "$CONVERT" "$PNG_file" -quality 100 "$JPG_file"

  rm -rf "$PNG_file"
fi

done
done
done

for theme in '' '-nord'; do

FILE_ID="wave-color${theme}"
SRC_FILE="src/wallpaper-wave${theme}.svg"
PNG_file="wallpapers${theme}/$FILE_ID.png"
JPG_file="wallpapers${theme}/$FILE_ID.jpg"

if [[ -f "$JPG_file" ]]; then
  echo "'$JPG_file' exist! "
else
  echo "Rendering '$PNG_file'"
    "$INKSCAPE" --export-id="$FILE_ID" \
                --export-id-only \
                --export-dpi="$DPI" \
                --export-filename="$PNG_file" "$SRC_FILE" >/dev/null

  echo "Rendering '$JPG_file'"
  "$CONVERT" "$PNG_file" -quality 100 "$JPG_file"

  rm -rf "$PNG_file"
fi

done


