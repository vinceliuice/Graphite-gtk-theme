#!/bin/bash

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
WALLPAPER_DIR="$HOME/.local/share/Graphite-backgrounds"
XML_DIR="$HOME/.local/share/gnome-background-properties"
old_string="@BACKGROUNDDIR@"


THEME_NAME='Graphite'
THEME_VARIANTS=('' '-nord')

#COLORS
CDEF=" \033[0m"                               # default color
CCIN=" \033[0;36m"                            # info color
CGSC=" \033[0;32m"                            # success color
CRER=" \033[0;31m"                            # error color
CWAR=" \033[0;33m"                            # waring color
b_CDEF=" \033[1;37m"                          # bold default color
b_CCIN=" \033[1;36m"                          # bold info color
b_CGSC=" \033[1;32m"                          # bold success color
b_CRER=" \033[1;31m"                          # bold error color
b_CWAR=" \033[1;33m"                          # bold warning color

# echo like ...  with  flag type  and display message  colors
prompt () {
  case ${1} in
    "-s"|"--success")
      echo -e "${b_CGSC}${@/-s/}${CDEF}";;    # print success message
    "-e"|"--error")
      echo -e "${b_CRER}${@/-e/}${CDEF}";;    # print error message
    "-w"|"--warning")
      echo -e "${b_CWAR}${@/-w/}${CDEF}";;    # print warning message
    "-i"|"--info")
      echo -e "${b_CCIN}${@/-i/}${CDEF}";;    # print info message
    *)
    echo -e "$@"
    ;;
  esac
}

install() {
  local theme="$1"

  prompt -i "\n * Install ${THEME_NAME}${theme} in ${WALLPAPER_DIR}... "
  mkdir -p "${WALLPAPER_DIR}"
  mkdir -p "${XML_DIR}"
  mkdir -p "${new_filepath}"

  cp -rf ${REPO_DIR}/${THEME_NAME}${theme}/*.png ${WALLPAPER_DIR}
  cp -rf ${REPO_DIR}/${THEME_NAME}${theme}/*.xml ${XML_DIR}
  for file in "$XML_DIR"/*; do
    sed -i "s/$old_string/$(printf '%s\n' "$WALLPAPER_DIR" | sed 's/[\/&]/\\&/g')/g" "$file"
  done
}

if [[ "${#themes[@]}" -eq 0 ]] ; then
  themes=("${THEME_VARIANTS[@]}")
fi

install_wallpaper() {
  for theme in "${themes[@]}"; do
    install "$theme"
  done
}

install_wallpaper

prompt -s "\n * All done!"
echo

