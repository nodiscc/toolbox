#!/bin/bash
#Description: update an APT repository with packages in pool/main direcotry; generate Packages/Releases files, sign.
#License: WTFPL
#Status: quick and dirty

#Set repository location
echo "REPO set to $REPO"
if [ ! -d $REPO ]
then
	echo "$REPO does not exist! Exiting..."; exit 1
fi

cd "$REPO" &&

#Generate Packages files
echo "Generating Packages files..."
#apt-ftparchive --arch i386 packages ./ > | gzip -9c > ./dists/testing/main/binary-i386/Packages.gz
apt-ftparchive --arch i386 packages ./ > ./dists/testing/main/binary-i386/Packages
#apt-ftparchive --arch amd64 packages ./ | gzip -9c > ./dists/testing/main/binary-amd64/Packages.gz
apt-ftparchive --arch amd64 packages ./ > ./dists/testing/main/binary-amd64/Packages
#apt-ftparchive --arch all packages ./ | gzip -9c > ./dists/testing/main/binary-all/Packages.gz
apt-ftparchive --arch all packages ./ > ./dists/testing/main/binary-all/Packages

#Release file header
echo "Origin: vendorname
Suite: testing
Label: Rxtx Linux
Components: main
Date: `date`
Architectures: amd64 i386
Description: Rxtx Linux 0.9" > ./dists/testing/Release

#Generate Release File
echo "Generating main Release file..."
apt-ftparchive release ./dists/testing/ >> ./dists/testing/Release

#Sign Release file
echo "Signing release file..."
gpg -abs -o ./dists/testing/Release.gpg ./dists/testing/Release
