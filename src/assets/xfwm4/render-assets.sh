#! /usr/bin/env bash

INKSCAPE="/usr/bin/inkscape"
OPTIPNG="/usr/bin/optipng"

svg_main() {
  local color="${1}"
  local screen="${2}"

  local SRC_FILE="assets-${type}${color}${screen}.svg"
  local ASSETS_DIR="${type}/assets${color}${screen}"

  mkdir -p "$ASSETS_DIR"

  if [[ -f "$ASSETS_DIR/$i.svg" ]]; then
    echo -e "$ASSETS_DIR/$i.svg exists."
  else
    echo
    echo -e "Rendering $ASSETS_DIR/$i.svg"
    $INKSCAPE --export-id=$i \
              --export-id-only \
              --export-filename=$ASSETS_DIR/$i.svg $SRC_FILE >/dev/null
    svgo "$ASSETS_DIR/$i.svg"
  fi
}

xpm_main() {
  local screen="${1}"

  local SRC_FILE="assets-${type}.svg"
  local ASSETS_DIR="${type}/assets${screen}"

  case "${screen}" in
    -hdpi)
      DPI='144'
      ;;
    -xhdpi)
      DPI='192'
      ;;
    *)
      DPI='96'
      ;;
  esac

  mkdir -p "$ASSETS_DIR"

  if [[ -f "$ASSETS_DIR/$i.xpm" ]]; then
    echo -e "$ASSETS_DIR/$i.xpm exists."
  else
    echo
    echo -e "Rendering $ASSETS_DIR/$i.xpm"
    $INKSCAPE --export-id=$i \
              --export-id-only \
              --export-dpi=$DPI \
              --export-filename=$ASSETS_DIR/$i.png $SRC_FILE >/dev/null
    convert "$ASSETS_DIR/$i.png" "$ASSETS_DIR/$i.xpm"
    sed -i "s/c #2C2C2C/c #2C2C2C s active_color_2/g" "$ASSETS_DIR/$i.xpm"
    sed -i "s/c gray88/c gray88 s active_color_1/g" "$ASSETS_DIR/$i.xpm"
    rm -rf $ASSETS_DIR/$i.png
  fi

  (
  cd $ASSETS_DIR
  ln -sf button.xpm close-active.xpm
  ln -sf button.xpm close-prelight.xpm
  ln -sf button.xpm close-pressed.xpm
  ln -sf button.xpm close-inactive.xpm
  ln -sf button.xpm hide-active.xpm
  ln -sf button.xpm hide-prelight.xpm
  ln -sf button.xpm hide-pressed.xpm
  ln -sf button.xpm hide-inactive.xpm
  ln -sf button.xpm maximize-active.xpm
  ln -sf button.xpm maximize-prelight.xpm
  ln -sf button.xpm maximize-pressed.xpm
  ln -sf button.xpm maximize-inactive.xpm
  ln -sf button.xpm maximize-toggled-active.xpm
  ln -sf button.xpm maximize-toggled-prelight.xpm
  ln -sf button.xpm maximize-toggled-pressed.xpm
  ln -sf button.xpm maximize-toggled-inactive.xpm
  ln -sf button.xpm shade-active.xpm
  ln -sf button.xpm shade-prelight.xpm
  ln -sf button.xpm shade-pressed.xpm
  ln -sf button.xpm shade-inactive.xpm
  ln -sf button.xpm shade-toggled-active.xpm
  ln -sf button.xpm shade-toggled-prelight.xpm
  ln -sf button.xpm shade-toggled-pressed.xpm
  ln -sf button.xpm shade-toggled-inactive.xpm
  ln -sf button.xpm stick-active.xpm
  ln -sf button.xpm stick-prelight.xpm
  ln -sf button.xpm stick-pressed.xpm
  ln -sf button.xpm stick-inactive.xpm
  ln -sf button.xpm stick-toggled-active.xpm
  ln -sf button.xpm stick-toggled-prelight.xpm
  ln -sf button.xpm stick-toggled-pressed.xpm
  ln -sf button.xpm stick-toggled-inactive.xpm
  ln -sf button.xpm menu-active.xpm
  ln -sf button.xpm menu-prelight.xpm
  ln -sf button.xpm menu-pressed.xpm
  ln -sf button.xpm menu-inactive.xpm
  ln -sf title.xpm title-1-active.xpm
  ln -sf title.xpm title-2-active.xpm
  ln -sf title.xpm title-3-active.xpm
  ln -sf title.xpm title-4-active.xpm
  ln -sf title.xpm title-5-active.xpm
  ln -sf title.xpm title-1-inactive.xpm
  ln -sf title.xpm title-2-inactive.xpm
  ln -sf title.xpm title-3-inactive.xpm
  ln -sf title.xpm title-4-inactive.xpm
  ln -sf title.xpm title-5-inactive.xpm
  ln -sf top-left-active.xpm top-left-inactive.xpm
  ln -sf top-right-active.xpm top-right-inactive.xpm
  ln -sf left-active.xpm left-inactive.xpm
  ln -sf left-active.xpm right-active.xpm
  ln -sf right-active.xpm right-inactive.xpm
  ln -sf bottom-active.xpm bottom-inactive.xpm
  ln -sf bottom-left-active.xpm bottom-left-inactive.xpm
  ln -sf bottom-right-active.xpm bottom-right-inactive.xpm
  )
}

make_svg() {
  local type="svg"
  local INDEX="assets-${type}.txt"

  for i in `cat $INDEX`; do
    for color in '' '-Light'; do
      for screen in '' '-hdpi' '-xhdpi'; do
        svg_main "${color}" "${screen}"
      done
    done
  done
}

make_xpm() {
  local type="xpm"
  local INDEX="assets-${type}.txt"

  for i in `cat $INDEX`; do
    for screen in '' '-hdpi' '-xhdpi'; do
      xpm_main "${screen}"
    done
  done
}

make_svg && make_xpm

