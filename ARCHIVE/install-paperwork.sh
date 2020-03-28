#!/bin/bash
# Description: install paperwork - https://openpaper.work/
# https://gitlab.gnome.org/World/OpenPaperwork/paperwork
# https://bugs.debian.org/721287
 
sudo apt install libenchant-dev python3-dev python3-pil python3-pip python3-setuptools python3-venv python3-whoosh tesseract-ocr tesseract-ocr-fra libcairo2-dev libgirepository1.0-dev
mkdir -p ~/.local/venv
pip3 -m venv ~/.local/venv/paperwork
source ~/.local/venv/bin/activate
pip3 install paperwork PyGObject insane
~/.local/venvs/paperwork/bin/paperwork-shell chkdeps paperwork_backend
~/.local/venvs/paperwork/bin/paperwork-shell chkdeps paperwork

# Example .desktop launcher
# $ cat ~/.local/share/applications/paperwork.desktop
# [Desktop Entry]
# Version=1.0
# Type=Application
# Name=Paperwork
# Comment=Personal document manager
# Comment[fr]=Gestionnaire de documents
# Exec=/home/{{ ansible_user }}/.local/venvs/paperwork/bin/paperwork
# Icon=/home/{{ ansible_user }}/.local/venvs/paperwork/lib/python3.5/site-packages/paperwork/frontend/data/paperwork.svg
# Path=
# Terminal=false
# StartupNotify=true
