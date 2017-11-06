#!/bin/bash

function check_exist {
  if [ -f "/etc/pacman.d/mirrorlist.pacnew" ]; then
  sudo rm mirrorlist.pacnew
  fi
}

function generate {
check_exist
cd /etc/pacman.d/
echo "Downloading newly generated mirrorlist"
sudo wget -q -O mirrorlist.pacnew https://www.archlinux.org/mirrorlist/?country=all&protocol=http&ip_version=4
sudo reflector --verbose -l 200 -p http --sort rate --save /etc/pacman.d/mirrorlist.pacnew
}

case "$1" in
  "--silent")
  generate
  ;;
  *)
  echo -n "Do you want to download mirrors?: "
  read choise
  case "$choise" in
    y|Y) generate ;;
    *) exit 1 ;;
  esac
  ;;
esac
