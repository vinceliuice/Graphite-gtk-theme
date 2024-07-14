#! /bin/bash

THEME_DIR=$(cd $(dirname $0) && pwd)

THEME_NAME=Graphite

_COLOR_VARIANTS=('' '-Light' '-Dark')
_SCHEME_VARIANTS=('' '-nord')
_THEME_VARIANTS=('' '-purple' '-pink' '-red' '-orange' '-yellow' '-green' '-grey' '-teal')

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
for theme in "${_THEME_VARIANTS[@]}"; do
  rm -rf ${THEME_NAME}${theme}.tar
  rm -rf ${THEME_NAME}${theme}.tar.xz
done

for theme in "${_THEME_VARIANTS[@]}"; do
  tar -Jcvf ${THEME_NAME}${theme}${type}.tar.xz ${THEME_NAME}${theme}{'','-Light','-Dark'}
done
}

Clear_theme() {
for theme in "${_THEME_VARIANTS[@]}"; do
  for color in "${_COLOR_VARIANTS[@]}"; do
    rm -rf ${THEME_NAME}${theme}${color}{'','-hdpi','-xhdpi'}
  done
done
}

cd .. && ./install.sh -d $THEME_DIR -t all
cd $THEME_DIR && Tar_themes && Clear_theme

