#! /usr/bin/env bash

# Grub2 Themes
set  -o errexit

[  GLOBAL::CONF  ]
{
readonly ROOT_UID=0
readonly Project_Name="GRUB2::THEMES"
readonly MAX_DELAY=20                               # max delay for user to enter root password
tui_root_login=

DEST_DIR="/usr/share/grub/themes"
REO_DIR="$(cd $(dirname $0) && pwd)"
}

name=Graphite
SCREEN_VARIANTS=('1080p' '2k' '4k')

#COLORS
CDEF=" \033[0m"                                     # default color
CCIN=" \033[0;36m"                                  # info color
CGSC=" \033[0;32m"                                  # success color
CRER=" \033[0;31m"                                  # error color
CWAR=" \033[0;33m"                                  # waring color
b_CDEF=" \033[1;37m"                                # bold default color
b_CCIN=" \033[1;36m"                                # bold info color
b_CGSC=" \033[1;32m"                                # bold success color
b_CRER=" \033[1;31m"                                # bold error color
b_CWAR=" \033[1;33m"                                # bold warning color

# echo like ... with flag type and display message colors
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

# Check command availability
function has_command() {
  command -v $1 > /dev/null
}

usage() {
  printf "%s\n" "Usage: ${0##*/} [OPTIONS...]"
  printf "\n%s\n" "OPTIONS:"
  printf "  %-25s%s\n" "-b, --boot" "install grub theme into /boot/grub/themes"
  printf "  %-25s%s\n" "-s, --screen" "screen display variant(s) [1080p|2k|4k] (default is 1080p)"
  printf "  %-25s%s\n" "-r, --remove" "Remove theme (must add theme name option)"
  printf "  %-25s%s\n" "-h, --help" "Show this help"
}

install() {
  local screen="${1}"

  local THEME_DIR="${DEST_DIR}/${name}"

  # Check for root access and proceed if it is present
  if [[ "$UID" -eq "$ROOT_UID" ]]; then
    clear

    # Create themes directory if it didn't exist
    prompt -s "\n Checking for the existence of themes directory..."

    [[ -d "${THEME_DIR}" ]] && rm -rf "${THEME_DIR}"
    mkdir -p "${THEME_DIR}"

    # Copy theme
    prompt -s "\n Installing ${name} ${screen} theme..."

    # Don't preserve ownership because the owner will be root, and that causes the script to crash if it is ran from terminal by sudo
    cp -a --no-preserve=ownership "${REO_DIR}/common/"{*.png,*.pf2} "${THEME_DIR}"
    cp -a --no-preserve=ownership "${REO_DIR}/config/theme-${screen}.txt" "${THEME_DIR}/theme.txt"
    cp -a --no-preserve=ownership "${REO_DIR}/backgrounds/${screen}/wave-dark.png" "${THEME_DIR}/${theme}/background.png"
    cp -a --no-preserve=ownership "${REO_DIR}/assets/logos/${screen}" "${THEME_DIR}/${theme}/icons"
    cp -a --no-preserve=ownership "${REO_DIR}/assets/assets/${screen}/"*.png "${THEME_DIR}/${theme}"

    # Set theme
    prompt -s "\n Setting ${name} as default..."

    # Backup grub config
    cp -an /etc/default/grub /etc/default/grub.bak

    # Fedora workaround to fix the missing unicode.pf2 file (tested on fedora 34): https://bugzilla.redhat.com/show_bug.cgi?id=1739762
    # This occurs when we add a theme on grub2 with Fedora.
    if has_command dnf; then
      if [[ -f "/boot/grub2/fonts/unicode.pf2" ]]; then
        if grep "GRUB_FONT=" /etc/default/grub 2>&1 >/dev/null; then
          #Replace GRUB_FONT
          sed -i "s|.*GRUB_FONT=.*|GRUB_FONT=/boot/grub2/fonts/unicode.pf2|" /etc/default/grub
        else
          #Append GRUB_FONT
          echo "GRUB_FONT=/boot/grub2/fonts/unicode.pf2" >> /etc/default/grub
        fi
      elif [[ -f "/boot/efi/EFI/fedora/fonts/unicode.pf2" ]]; then
        if grep "GRUB_FONT=" /etc/default/grub 2>&1 >/dev/null; then
          #Replace GRUB_FONT
          sed -i "s|.*GRUB_FONT=.*|GRUB_FONT=/boot/efi/EFI/fedora/fonts/unicode.pf2|" /etc/default/grub
        else
          #Append GRUB_FONT
          echo "GRUB_FONT=/boot/efi/EFI/fedora/fonts/unicode.pf2" >> /etc/default/grub
        fi
      fi
    fi

    if grep "GRUB_THEME=" /etc/default/grub 2>&1 >/dev/null; then
      #Replace GRUB_THEME
      sed -i "s|.*GRUB_THEME=.*|GRUB_THEME=\"${THEME_DIR}/theme.txt\"|" /etc/default/grub
    else
      #Append GRUB_THEME
      echo "GRUB_THEME=\"${THEME_DIR}/theme.txt\"" >> /etc/default/grub
    fi

    # Make sure the right resolution for grub is set
    if [[ ${screen} == '1080p' ]]; then
      gfxmode="GRUB_GFXMODE=1920x1080,auto"
    elif [[ ${screen} == '4k' ]]; then
      gfxmode="GRUB_GFXMODE=3840x2160,auto"
    elif [[ ${screen} == '2k' ]]; then
      gfxmode="GRUB_GFXMODE=2560x1440,auto"
    fi

    if grep "GRUB_GFXMODE=" /etc/default/grub 2>&1 >/dev/null; then
      #Replace GRUB_GFXMODE
      sed -i "s|.*GRUB_GFXMODE=.*|${gfxmode}|" /etc/default/grub
    else
      #Append GRUB_GFXMODE
      echo "${gfxmode}" >> /etc/default/grub
    fi

    if grep "GRUB_TERMINAL=console" /etc/default/grub 2>&1 >/dev/null || grep "GRUB_TERMINAL=\"console\"" /etc/default/grub 2>&1 >/dev/null; then
      #Replace GRUB_TERMINAL
      sed -i "s|.*GRUB_TERMINAL=.*|#GRUB_TERMINAL=console|" /etc/default/grub
    fi

    if grep "GRUB_TERMINAL_OUTPUT=console" /etc/default/grub 2>&1 >/dev/null || grep "GRUB_TERMINAL_OUTPUT=\"console\"" /etc/default/grub 2>&1 >/dev/null; then
      #Replace GRUB_TERMINAL_OUTPUT
      sed -i "s|.*GRUB_TERMINAL_OUTPUT=.*|#GRUB_TERMINAL_OUTPUT=console|" /etc/default/grub
    fi

    # For Kali linux
    if [[ -f "/etc/default/grub.d/kali-themes.cfg" ]]; then
      cp -an /etc/default/grub.d/kali-themes.cfg /etc/default/grub.d/kali-themes.cfg.bak
      sed -i "s|.*GRUB_GFXMODE=.*|${gfxmode}|" /etc/default/grub.d/kali-themes.cfg
      sed -i "s|.*GRUB_THEME=.*|GRUB_THEME=\"${THEME_DIR}/theme.txt\"|" /etc/default/grub.d/kali-themes.cfg
    fi

    # Update grub config
    prompt -s "\n Updating grub config...\n"

    updating_grub

    prompt -w "\n * At the next restart of your computer you will see your new Grub theme: '${name}' "
  else
    #Check if password is cached (if cache timestamp not expired yet)
    sudo -n true 2> /dev/null && echo

    if [[ $? == 0 ]]; then
      #No need to ask for password
      sudo "$0" -s ${screen}
    else
      #Ask for password
      if [[ -n ${tui_root_login} ]] ; then
        if [[ -n "${screen}" ]]; then
          sudo -S $0 -s ${screen} <<< ${tui_root_login}
        fi
      else
        prompt -e "\n [ Error! ] -> Run me as root! "
        read -p " [ Trusted ] Specify the root password : " -t ${MAX_DELAY} -s

        sudo -S echo <<< $REPLY 2> /dev/null && echo

        if [[ $? == 0 ]]; then
          #Correct password, use with sudo's stdin
          sudo -S "$0" -s ${screen} <<< ${REPLY}
        else
          #block for 3 seconds before allowing another attempt
          sleep 3
          prompt -e "\n [ Error! ] -> Incorrect password!\n"
          exit 1
        fi
      fi
    fi
 fi
}

updating_grub() {
  if has_command update-grub; then
    update-grub
  elif has_command grub-mkconfig; then
    grub-mkconfig -o /boot/grub/grub.cfg
  elif has_command zypper; then
    grub2-mkconfig -o /boot/grub2/grub.cfg
  elif has_command dnf; then
    if [[ -f /boot/efi/EFI/fedora/grub.cfg ]]; then
      prompt -i "Find config file on /boot/efi/EFI/fedora/grub.cfg ...\n"
      grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
    fi
    if [[ -f /boot/grub2/grub.cfg ]]; then
      prompt -i "Find config file on /boot/grub2/grub.cfg ...\n"
      grub2-mkconfig -o /boot/grub2/grub.cfg
    fi
  fi

  # Success message
  prompt -s "\n * All done!"
}

remove() {
  local THEME_DIR="${DEST_DIR}/${name}"

  # Check for root access and proceed if it is present
  if [ "$UID" -eq "$ROOT_UID" ]; then
    echo -e "\n Checking for the existence of themes directory..."
    if [[ -d "${THEME_DIR}" ]]; then
      rm -rf "${THEME_DIR}"
    else
      prompt -e "\n ${name} grub theme not exist!"
      exit 0
    fi

    # Backup grub config
    if [[ -f "/etc/default/grub.bak" ]]; then
      rm -rf /etc/default/grub && mv /etc/default/grub.bak /etc/default/grub
    else
      prompt -e "\n grub.bak not exist!"
      exit 0
    fi

    # For Kali linux
    if [[ -f "/etc/default/grub.d/kali-themes.cfg.bak" ]]; then
      rm -rf /etc/default/grub.d/kali-themes.cfg && mv /etc/default/grub.d/kali-themes.cfg.bak /etc/default/grub.d/kali-themes.cfg
    fi

    # Update grub config
    prompt -s "\n Resetting grub theme...\n"

    updating_grub

  else
    #Check if password is cached (if cache timestamp not expired yet)
    sudo -n true 2> /dev/null && echo

    if [[ $? == 0 ]]; then
      #No need to ask for password
      sudo "$0" "${PROG_ARGS[@]}"
    else
      #Ask for password
      prompt -e "\n [ Error! ] -> Run me as root! "
      read -p " [ Trusted ] Specify the root password : " -t ${MAX_DELAY} -s

      sudo -S echo <<< $REPLY 2> /dev/null && echo

      if [[ $? == 0 ]]; then
        #Correct password, use with sudo's stdin
        sudo -S "$0" "${PROG_ARGS[@]}" <<< $REPLY
      else
        #block for 3 seconds before allowing another attempt
        sleep 3
        clear
        prompt -e "\n [ Error! ] -> Incorrect password!\n"
        exit 1
      fi
    fi
  fi
}

while [[ $# -gt 0 ]]; do
  PROG_ARGS+=("${1}")
  dialog='false'
  case "${1}" in
    -b|--boot)
      THEME_DIR="/boot/grub/themes"
      shift 1
      ;;
    -r|--remove)
      remove='true'
      shift 1
      ;;
    -s|--screen)
      shift
      for screen in "${@}"; do
        case "${screen}" in
          1080p)
            screens+=("${SCREEN_VARIANTS[0]}")
            shift
            ;;
          2k)
            screens+=("${SCREEN_VARIANTS[1]}")
            shift
            ;;
          4k)
            screens+=("${SCREEN_VARIANTS[2]}")
            shift
            ;;
          -*|--*)
            break
            ;;
          *)
            prompt -e "ERROR: Unrecognized screen variant '$1'."
            prompt -i "Try '$0 --help' for more information."
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
      prompt -e "ERROR: Unrecognized installation option '$1'."
      prompt -i "Try '$0 --help' for more information."
      exit 1
      ;;
  esac
done

if [[ "${remove:-}" == 'true' ]]; then
  remove
else
  for screen in "${screens[@]-${SCREEN_VARIANTS[0]}}"; do
    install "${screen}"
  done
fi

exit 1
