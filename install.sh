#!/bin/bash

if [ "x$(id -u)" != 'x0' ]; then
    echo 'Error: this script can only be executed by root'
    exit 1
fi

function install {
if [ "$op" == "install" ]; then
cp reflect_mirrors.sh /bin/reflect_mirrors.sh
cp mirrors.hook /etc/pacman.d/hooks/mirrors.hook
else
rm /bin/reflect_mirrors.sh
rm /etc/pacman.d/hooks/mirrors.hook
fi
}

if ! [ -f /bin/reflect_mirrors.sh ]; then
echo "Installing..."
op=install
install
else
echo "Removing..."
install
fi
