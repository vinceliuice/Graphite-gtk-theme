#! /bin/bash

THEME_DIR=$(cd $(dirname $0) && pwd)

THEME_NAME=Graphite

_COLOR_VARIANTS=('' '-Light' '-Dark')
_SCHEME_VARIANTS=('' '-nord')
_THEME_VARIANTS=('' '-purple' '-pink' '-red' '-orange' '-yellow' '-green' '-blue' '-teal')
_TYPE_VARIANTS=('-rimless' '-outlined')

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
for theme in "${_THEME_VARIANTS[8]}"; do
  for scheme in "${_SCHEME_VARIANTS[1]}"; do
    rm -rf ${THEME_NAME}${theme}${scheme}${type}.tar
    rm -rf ${THEME_NAME}${theme}${scheme}${type}.tar.xz
  done
done

for theme in "${_THEME_VARIANTS[8]}"; do
  for scheme in "${_SCHEME_VARIANTS[1]}"; do
    tar -Jcvf ${THEME_NAME}${theme}${scheme}${type}.tar.xz ${THEME_NAME}${theme}{'','-Light','-Dark'}${scheme}
  done
done
}

Clear_theme() {
for theme in "${_THEME_VARIANTS[8]}"; do
  for color in "${_COLOR_VARIANTS[@]}"; do
    for scheme in "${_SCHEME_VARIANTS[1]}"; do
      rm -rf ${THEME_NAME}${theme}${color}${scheme}{'','-hdpi','-xhdpi'}
    done
  done
done
}

type="-rimless"
cd .. && ./install.sh -d $THEME_DIR --tweaks float colorful nord rimless -t teal
cd $THEME_DIR && Tar_themes && Clear_theme
type="-outlined"
cd .. && ./install.sh -d $THEME_DIR --tweaks float colorful nord -t teal
cd $THEME_DIR && Tar_themes && Clear_theme

