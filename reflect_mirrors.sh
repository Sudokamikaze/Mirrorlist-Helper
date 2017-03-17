#!/bin/bash

hardcoded=false

function generate {
cd /tmp
echo "Downloading newly generated mirrorlist"
wget -q -O mirrorlist.tmp https://www.archlinux.org/mirrorlist/?country=all&protocol=http&ip_version=4
sudo cp mirrorlist.tmp /etc/pacman.d/mirrorlist.pacnew
rm mirrorlist.tmp
check
}


function check {
varforcheck=$(ls /etc/pacman.d | grep "mirrorlist.pacnew")
case "$varforcheck" in
  mirrorlist.pacnew)
echo "Mirrorlist was found!"
sudo reflector --verbose -l 200 -p http --sort rate --save /etc/pacman.d/mirrorlist.pacnew
cd /etc/pacman.d/
sudo rm mirrorlist && sudo mv mirrorlist.pacnew mirrorlist
  ;;
  *)
  echo " "
  echo "New mirrorlist was not found."
  echo " "
  if [ "$hardcoded" == "false" ]; then
  echo -n "Do you want to generate new mirrorlist?[Y/N]: "
  read newmirror
  if [ "$newmirror" == "y" ]; then
  generate
elif [ "$newmirror" == "Y" ]; then
  generate
fi
fi
esac
}

if [ "$hardcoded" == "false" ]; then
echo -n "Do you want to processed mirrors?[Y/N]: "
read menu
case "$menu" in
  y|Y) check
  ;;
  n|N|*) exit
  ;;
esac
else
  check
fi
