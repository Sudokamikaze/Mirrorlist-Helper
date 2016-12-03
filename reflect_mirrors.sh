#!/bin/bash

function check {
if grep -qs 'mirrorlist.pacnew' /etc/pacman.d; then
sudo reflector --verbose -l 200 -p http --sort rate --save /etc/pacman.d/mirrorlist.pacnew
cd /etc/pacman.d/
sudo rm mirrorlist && sudo mv mirrorlist.pacnew mirrorlist
else
  echo " "
  echo "New mirrorlist was not found. To fix this update pacman-mirrorlist"
  exit
fi
}

echo -n "Do you want to processed mirrors?[Y/N]: "
read menu
case "$menu" in
  y|Y) check
  ;;
  n|N|*) exit
  ;;
esac

echo "Running force update to test new mirrors"
sudo pacman -Syyu
echo Done!
