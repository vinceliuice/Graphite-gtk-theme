#! /bin/bash

THEME_DIR=$(cd $(dirname $0) && pwd)

THEME_NAME=Graphite

_COLOR_VARIANTS=('' '-Light' '-Dark')
_SCHEME_VARIANTS=('' '-nord')
_THEME_VARIANTS=('' '-purple' '-pink' '-red' '-orange' '-yellow' '-green' '-blue' '-teal')

if [ ! -z "${COLOR_VARIANTS:-}" ]; then
  IFS=', ' read -r -a _COLOR_VARIANTS <<< "${COLOR_VARIANTS:-}"
fi

if [ ! -z "${SCHEME_VARIANTS:-}" ]; then
  IFS=', ' read -r -a _SCHEME_VARIANTS <<< "${SCHEME_VARIANTS:-}"
fi

if [ ! -z "${THEME_VARIANTS:-}" ]; then
  IFS=', ' read -r -a _THEME_VARIANTS <<< "${THEME_VARIANTS:-}"
fi

Tar_themes() {
  for color in "${_COLOR_VARIANTS[@]}"; do
    rm -rf ${THEME_NAME}${color}${scheme}.tar
    rm -rf ${THEME_NAME}${color}${scheme}.tar.xz
  done

  for color in "${_COLOR_VARIANTS[@]}"; do
    tar -cf ${THEME_NAME}${color}${scheme}.tar ${THEME_NAME}{'','-purple','-pink','-red','-orange','-yellow','-green','-blue','-teal'}${color}${scheme}
  done

  for color in "${_COLOR_VARIANTS[@]}"; do
    xz -z ${THEME_NAME}${color}${scheme}.tar
  done
}

Clear_theme() {
  for theme in "${_THEME_VARIANTS[@]}"; do
    for color in "${_COLOR_VARIANTS[@]}"; do
      rm -rf ${THEME_NAME}${theme}${color}${scheme}{'','-hdpi','-xhdpi'}
      echo "Clear ${THEME_NAME}${theme}${color}${scheme}"
    done
  done
}

scheme=''
cd .. && ./install.sh -d "$THEME_DIR" -t all
cd "$THEME_DIR" && Tar_themes "$scheme" && Clear_theme "$scheme"

scheme='-nord'
cd .. && ./install.sh -d "$THEME_DIR" -t all --tweaks nord
cd "$THEME_DIR" && Tar_themes "$scheme" && Clear_theme "$scheme"

