#!/bin/bash
#Description: Install retroarch
#https://www.retroarch.com/index.php?page=linux-instructions
sudo apt install flatpak
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --user flathub org.libretro.RetroArch
# update
#flatpak update --user org.libretro.RetroArch