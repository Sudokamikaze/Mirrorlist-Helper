#!/bin/bash

if [ "x$(id -u)" != 'x0' ]; then
    echo 'Error: this script can only be executed by root'
    exit 1
fi

function install {
if [ "$op" == "install" ]; then
sed -i "s/hardcoded=false/hardcoded=true/g" ./reflect_mirrors.sh
cp reflect_mirrors.sh $paths/reflect_mirrors.sh
cp mirrors.hook /etc/pacman.d/hooks/mirrors.hook
sed -i "s/hardcoded=true/hardcoded=false/g" ./reflect_mirrors.sh
else
rm $paths/reflect_mirrors.sh
rm /etc/pacman.d/hooks/mirrors.hook
fi
}

function operations {
  if ! [ -f $paths/reflect_mirrors.sh ]; then
  echo "Installing..."
  op=install
  install
  else
  echo "Removing..."
  install
  fi
}

function call {
  case "$opt" in
    i) paths=$OPTARG
    ;;
    *) paths="/bin/"
    ;;
  esac
  operations
}

if [ $# = 0 ]; then
  operations
fi

while getopts "i:" opt ;
do
  case $opt in
    i)
    call
    exit 1
    ;;
    *)
    exit 1
    ;;
esac
done
