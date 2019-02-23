#!/bin/bash
#Description: LUKS keyfile creation wizard
#Create a LUKS key file, add it to the specified volume, set up automount for it
#Must be run as root
#TODO: add root check
#TODO: specify targetdrive (or file) and mapper name in command line
#TODO: add option to create luks volume before setting up the key

#Vars
set -e
TargetDrive="/dev/sda"
MapperName="cryptvolume"
MountPoint="/media/$MapperName"
Keyfile="/etc/keyfile-$MapperName"

#Keyfile generation
echo "Generating keyfile in $Keyfile..."
sudo dd if=/dev/urandom of="$Keyfile" bs=1024 count=4
sudo chmod 0400 "$Keyfile"

#add keyfile to target drive
sudo cryptsetup luksAddKey "$TargetDrive" "$Keyfile"
echo "Keyfile added to target drive"

#add entry to crypttab
CrypttabLine="$MapperName $TargetDrive $Keyfile luks"
echo -e  "\n $CrypttabLine" | tee -a /etc/crypttab
echo "Entry added to crypttab"


#add entry to fstab and mount
sudo nano /etc/fstab
FstabLine="/dev/mapper/$MapperName $MountPoint ext4 defaults 0 2"
echo -e "\n $FstabLine" | tee -a /etc/fstab
echo "Entry added to fstab"
sudo mount -a
echo "Drive mounted. Have a nice day."

#detect luks partitions
#for i in * ; do cryptsetup luksDump $i 2>/dev/null|grep UUID; done
