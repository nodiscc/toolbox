#!/bin/bash
#Description: Fix the "corrupted package lists" Debian/APT error

sudo apt-get clean
sudo rm -r /var/lib/apt/lists
sudo mkdir -p /var/lib/apt/lists/partial
sudo apt-get clean
sudo aptitude update
