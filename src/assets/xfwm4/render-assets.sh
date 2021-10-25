#! /bin/bash

INKSCAPE="/usr/bin/inkscape"
OPTIPNG="/usr/bin/optipng"

ASSETS_DIR="assets"
HD_ASSETS_DIR="assets-hdpi"
XHD_ASSETS_DIR="assets-xhdpi"
SRC_FILE="assets.svg"

LIGHT_ASSETS_DIR="assets-light"
LIGHT_HD_ASSETS_DIR="assets-light-hdpi"
LIGHT_XHD_ASSETS_DIR="assets-light-xhdpi"
LIGHT_SRC_FILE="assets-light.svg"

INDEX="assets.txt"

for i in `cat $INDEX`
do

# Normal

if [ -f $ASSETS_DIR/$i.png ]; then
    echo $ASSETS_DIR/$i.png exists.
else
    echo
    echo Rendering $ASSETS_DIR/$i.png
    $INKSCAPE --export-id=$i \
              --export-id-only \
              --export-filename=$ASSETS_DIR/$i.png $SRC_FILE >/dev/null \
    && $OPTIPNG -o7 --quiet $ASSETS_DIR/$i.png 
fi
if [ -f $LIGHT_ASSETS_DIR/$i.png ]; then
    echo $LIGHT_ASSETS_DIR/$i.png exists.
else
    echo
    echo Rendering $LIGHT_ASSETS_DIR/$i.png
    $INKSCAPE --export-id=$i \
              --export-id-only \
              --export-filename=$LIGHT_ASSETS_DIR/$i.png $LIGHT_SRC_FILE >/dev/null \
    && $OPTIPNG -o7 --quiet $LIGHT_ASSETS_DIR/$i.png 
fi

# HDPI

if [ -f $HD_ASSETS_DIR/$i.png ]; then
    echo $HD_ASSETS_DIR/$i.png exists.
else
    echo
    echo Rendering $HD_ASSETS_DIR/$i.png
    $INKSCAPE --export-id=$i \
              --export-id-only \
              --export-dpi=144 \
              --export-filename=$HD_ASSETS_DIR/$i.png $SRC_FILE >/dev/null \
    && $OPTIPNG -o7 --quiet $HD_ASSETS_DIR/$i.png 
fi
if [ -f $LIGHT_HD_ASSETS_DIR/$i.png ]; then
    echo $LIGHT_HD_ASSETS_DIR/$i.png exists.
else
    echo
    echo Rendering $LIGHT_HD_ASSETS_DIR/$i.png
    $INKSCAPE --export-id=$i \
              --export-id-only \
              --export-dpi=144 \
              --export-filename=$LIGHT_HD_ASSETS_DIR/$i.png $LIGHT_SRC_FILE >/dev/null \
    && $OPTIPNG -o7 --quiet $LIGHT_HD_ASSETS_DIR/$i.png 
fi

# XHDPI

if [ -f $XHD_ASSETS_DIR/$i.png ]; then
    echo $XHD_ASSETS_DIR/$i.png exists.
else
    echo
    echo Rendering $XHD_ASSETS_DIR/$i.png
    $INKSCAPE --export-id=$i \
              --export-id-only \
              --export-dpi=192 \
              --export-filename=$XHD_ASSETS_DIR/$i.png $SRC_FILE >/dev/null \
    && $OPTIPNG -o7 --quiet $XHD_ASSETS_DIR/$i.png 
fi
if [ -f $LIGHT_XHD_ASSETS_DIR/$i.png ]; then
    echo $LIGHT_XHD_ASSETS_DIR/$i.png exists.
else
    echo
    echo Rendering $LIGHT_XHD_ASSETS_DIR/$i.png
    $INKSCAPE --export-id=$i \
              --export-id-only \
              --export-dpi=192 \
              --export-filename=$LIGHT_XHD_ASSETS_DIR/$i.png $LIGHT_SRC_FILE >/dev/null \
    && $OPTIPNG -o7 --quiet $LIGHT_XHD_ASSETS_DIR/$i.png 
fi

done
exit 0
