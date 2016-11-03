#!/bin/bash

function doreplace {
  echo -n "Do you want to replace old mirrorlist to new? [Y/n]"
  read replace
  case "$replace" in
    y|Y) echo "Starting replace"
    cd /etc/pacman.d/ && sudo rm mirrorlist && sudo mv mirrorlist.pacnew mirrorlist
     ;;
    n|N) exit
    ;;
esac
}

cd /tmp
echo =================================================
echo "1 - Force update with sudo pacman -S "
echo "2 - Download latest from pacman-mirrorlist generator"
echo "3 - Update current mirrorlist.pacnew"
echo =================================================
echo -n "Choose an action: "
read main
case "$main" in
  1) echo "Installing pacman-mirrorlist package"
  sudo pacman -S pacman-mirrorlist --noconfirm
  sudo reflector --verbose -l 200 -p http --sort rate --save /etc/pacman.d/mirrorlist.pacnew
  echo "Starting replace"
  cd /etc/pacman.d/
  sudo rm mirrorlist && sudo mv mirrorlist.pacnew mirrorlist
  ;;
  2) wget -O mirrorlist https://www.archlinux.org/mirrorlist/?country=all&protocol=http&ip_version=4
  sudo cp mirrorlist /etc/pacman.d/mirrorlist.pacnew
  echo "Running reflector"
  sudo reflector --verbose -l 200 -p http --sort rate --save /etc/pacman.d/mirrorlist.pacnew
  echo ""
  doreplace
  ;;
  3) echo "Updating mirrorlist file"
  sudo reflector --verbose -l 200 -p http --sort rate --save /etc/pacman.d/mirrorlist.pacnew
  cd /etc/pacman.d/
  sudo rm mirrorlist && sudo mv mirrorlist.pacnew mirrorlist
  ;;
  *) echo "Error, unknown symbol.. exiting...."
  ;;
esac
echo "Running force update to test new mirrors"
sudo pacman -Syyu
echo Done!