#!/bin/bash
#Description: build ALSA firmware (works with E-MU 0404 PCI soundcard)
#From: http://wiki.debian.org/snd-emu10k1
#License: MIT (http://opensource.org/licenses/MIT)

#Check for root privileges
if [[ "$USER" == "root" ]]; then
	true
	else echo "This script must be run as root"; exit 1
fi

#Install Build-essential
aptitude update &&
aptitude -Ry install build-essential &&

#get and uncompress the latest alsa firmwares
mkdir -p /tmp/alsafirmware/ &&
cd /tmp/alsafirmware/ &&
wget ftp://ftp.alsa-project.org/pub/firmware/alsa-firmware-1.0.29.tar.bz2 &&
tar xvf alsa-firmware-1.0.29.tar.bz2 &&

#Compile firmwares
cd alsa-firmware-1.0.29 &&
./configure --enable-buildfw &&
cd emu && make && make install

#Install firmwares and reload E-MU kernel module
mkdir -p /lib/firmware/emu
cp ./*fw /lib/firmware/emu/ &&
modprobe -r snd-emu10k1-synth snd-emu10k1; modprobe snd-emu10k1 &&

#Remove temporary build dir
cd / &&
rm -r /tmp/alsafirmware &&


#Set E-MU card as default
touch /etc/modprobe.d/99-alsa-default-emu.conf &&
echo "options snd-emu10k1 index=0
options snd slots=snd_emu10k1,snd_hda_intel
options snd_hda_intel index=1" >| /etc/modprobe.d/99-alsa-default-emu.conf &&

aplay -l
