#!/bin/bash
#Description: Builds a package from a directory. DIRTY, use devscripts instead
#TODO: check if directory contains DEBIAN/control
#TODO: automatic lintian check
#TODO: ignore .git directories

currentuser="$USER"
currentdir="$PWD"

#check if package directory exists
if [ -d "$1" ]
	then true
	else echo "Directory $1 does not exist"; exit 1
fi

#check if there is only 1 argument to the command
if [ "$2" != "" ]
	then echo "ERROR: only one argument is acceptable."; exit 1
fi

#build
echo "Setting owner to root..."
sudo chown -R root:root $1
echo "Building deb..."
sudo dpkg-deb --build $1
echo "Renaming deb..."
sudo dpkg-name *.deb
echo "Restoring owner..."
sudo chown -R $currentuser:$currentuser $1
sudo chown -R $currentuser:$currentuser *.deb
echo "Done."
