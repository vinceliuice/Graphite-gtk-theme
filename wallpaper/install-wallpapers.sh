#!/bin/bash

readonly ROOT_UID=0

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

if [[ "$UID" -eq "$ROOT_UID" ]]; then
  WALLPAPER_DIR="/usr/share/backgrounds"
  XML_DIR="/usr/share/gnome-background-properties"
else
  WALLPAPER_DIR="$HOME/.local/share/backgrounds"
  XML_DIR="$HOME/.local/share/gnome-background-properties"
fi

THEME_NAME='Graphite'
COLOR_VARIANTS=('-Light' '-Dark')
THEME_VARIANTS=('' '-nord')
SYSTEM_VARIANTS=('' '-arch' '-debian' '-fedora' '-manjaro' '-ubuntu' '-pop-os')

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

usage() {
cat << EOF
Usage: $0 [OPTION]...

OPTIONS:
  -t, --theme VARIANT     Specify theme variant [standard|nord] (Default: all variants)

  -c, --color VARIANT     Specify color variant(s) [light|dark] (Default: All variants))

  -s, --system VARIANT    Specify logo icon on wallpaper [default|arch|debian|fedora|manjaro|ubuntu|popos] (Default: no icon)

  -r, --remove,
  -u, --uninstall         Uninstall/Remove installed wallpapers

  -h, --help              Show help
EOF
}

install() {
  local color="$1"
  local theme="$2"
  local system="$3"

  local FILE_ID="wave${color}${theme}${system}"
  local JPG_file="wallpapers${theme}/$FILE_ID.jpg"

  prompt -i "\n * Install ${THEME_NAME}${theme}${system} in ${WALLPAPER_DIR}... "
  mkdir -p "${WALLPAPER_DIR}"
  mkdir -p "${XML_DIR}"

  cp -rf "${REPO_DIR}/${JPG_file}" "${WALLPAPER_DIR}"
  cp -rf "${REPO_DIR}/wallpaper.xml" "${XML_DIR}/${THEME_NAME}${theme}${system}.xml"
  sed -i "s/@NAME@/${THEME_NAME}${theme}${system}/g" "${XML_DIR}/${THEME_NAME}${theme}${system}.xml"
  sed -i "s/@BACKGROUNDDIR@/$(printf '%s\n' "${WALLPAPER_DIR}" | sed 's/[\/&]/\\&/g')/g" "${XML_DIR}/${THEME_NAME}${theme}${system}.xml"
  sed -i "s/@STRING@/${theme}${system}/g" "${XML_DIR}/${THEME_NAME}${theme}${system}.xml"
}

uninstall() {
  local color="$1"
  local theme="$2"
  local system="$3"

  local FILE_ID="wave${color}${theme}${system}"
  local JPG_file="wallpapers${theme}/$FILE_ID.jpg"

  prompt -i "\n * Uninstall ${THEME_NAME}${theme}${system} in ${WALLPAPER_DIR}... "

  rm -rf "${WALLPAPER_DIR}/$FILE_ID.jpg"
  rm -rf "${XML_DIR}/${THEME_NAME}${theme}${system}.xml"
}

while [[ $# -gt 0 ]]; do
  case "${1}" in
    -r|--remove|-u|--uninstall)
      uninstall="true"
      shift
      ;;
    -t|--theme)
      shift
      for theme in "${@}"; do
        case "${theme}" in
          standard)
            themes+=("${THEME_VARIANTS[0]}")
            shift
            ;;
          nord)
            themes+=("${THEME_VARIANTS[1]}")
            shift
            ;;
          -*|--*)
            break
            ;;
          *)
            echo "ERROR: Unrecognized theme variant '$1'."
            echo "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
      ;;
    -c|--color)
      shift
      for color in "${@}"; do
        case "${color}" in
          light)
            colors+=("${COLOR_VARIANTS[0]}")
            shift
            ;;
          dark)
            colors+=("${COLOR_VARIANTS[1]}")
            shift
            ;;
          -*|--*)
            break
            ;;
          *)
            echo "ERROR: Unrecognized color variant '$1'."
            echo "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
      ;;
    -s|--system)
      shift
      for system in "$@"; do
        case "$system" in
          default)
            systems+=("${SYSTEM_VARIANTS[0]}")
            shift
            ;;
          arch)
            systems+=("${SYSTEM_VARIANTS[1]}")
            compact='true'
            shift
            ;;
          debian)
            systems+=("${SYSTEM_VARIANTS[2]}")
            compact='true'
            shift
            ;;
          fedora)
            systems+=("${SYSTEM_VARIANTS[3]}")
            compact='true'
            shift
            ;;
          manjaro)
            systems+=("${SYSTEM_VARIANTS[4]}")
            compact='true'
            shift
            ;;
          ubuntu)
            systems+=("${SYSTEM_VARIANTS[5]}")
            compact='true'
            shift
            ;;
          popos)
            systems+=("${SYSTEM_VARIANTS[6]}")
            compact='true'
            shift
            ;;
          -*)
            break
            ;;
          *)
            echo "ERROR: Unrecognized sysytem variant '$1'."
            echo "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: Unrecognized installation option '$1'."
      echo "Try '$0 --help' for more information."
      exit 1
      ;;
  esac
done

if [[ "${#colors[@]}" -eq 0 ]] ; then
  colors=("${COLOR_VARIANTS[@]}")
fi

if [[ "${#themes[@]}" -eq 0 ]] ; then
  themes=("${THEME_VARIANTS[@]}")
fi

if [[ "${#systems[@]}" -eq 0 ]] ; then
  systems=("${SYSTEM_VARIANTS[@]}")
fi

install_wallpaper() {
  for color in "${colors[@]}"; do
    for theme in "${themes[@]}"; do
      for system in "${systems[@]}"; do
        install "$color" "$theme" "$system"
      done
    done
  done
}

uninstall_wallpaper() {
  for color in "${colors[@]}"; do
    for theme in "${themes[@]}"; do
      for system in "${systems[@]}"; do
        uninstall "$color" "$theme" "$system"
      done
    done
  done
}

if [[ "${uninstall}" != "true" ]]; then
  install_wallpaper
else
  uninstall_wallpaper
fi

prompt -s "\n * All done!"
echo

