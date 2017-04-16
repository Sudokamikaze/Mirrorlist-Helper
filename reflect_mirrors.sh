#!/bin/bash

function generate {
cd /tmp
echo "Downloading newly generated mirrorlist"
wget -q -O mirrorlist.tmp https://www.archlinux.org/mirrorlist/?country=all&protocol=http&ip_version=4
sudo cp mirrorlist.tmp /etc/pacman.d/mirrorlist.pacnew
rm mirrorlist.tmp
generated=true
check
}

function reflect {
  sudo reflector --verbose -l 200 -p http --sort rate --save /etc/pacman.d/mirrorlist.pacnew
  cd /etc/pacman.d/
  if  [ "$generated" == "true" ]; then
  sudo mv mirrorlist.pacnew mirrorlist
else
  sudo rm mirrorlist && sudo mv mirrorlist.pacnew mirrorlist
fi
}

function check {
varforcheck=$(ls /etc/pacman.d | grep "mirrorlist.pacnew")
case "$varforcheck" in
  mirrorlist.pacnew)
  echo " "
  echo "New mirrorlist was found."
  echo " "
  reflect
  ;;
  *)
  if [ "$opt" != "h" ]; then
  echo " "
  echo "New mirrorlist was not found."
  echo " "
  echo -n "Do you want to generate new mirrorlist?[Y/N]: "
  read newmirror
  if [ "$newmirror" == "y" ]; then
  generate
elif [ "$newmirror" == "Y" ]; then
  generate
fi
else
  echo "Mirrolist not found"
  exit 1
fi
esac

}

if [ $# = 0 ]; then
  echo -n "Do you want to processed mirrors?[Y/N]: "
  read menu
  case "$menu" in
    y|Y) check
    ;;
    n|N|*) exit
    ;;
  esac
fi

while getopts "h" opt ;
do
  case $opt in
    h) check
    ;;
esac
done
