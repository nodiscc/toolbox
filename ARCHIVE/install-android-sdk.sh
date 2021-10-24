#!/bin/bash
#Description: install Android SDK
#thx http://techapple.net/2014/07/runinstall-official-android-sdk-emulator-linux-ubuntulinuxmint/
set -o errexit
set -o nounset

cd "$HOME"
sudo aptitude install openjdk-6-jre openjdk-6-jdk icedtea6-plugin
wget http://dl.google.com/android/android-sdk_r24.4-linux.tgz
tar -xvzf android-sdk_r24.4-linux.tgz
cd ~/android-sdk-linux/tools
./android

#to run
#export PATH=${PATH}:~/android-sdk-linux/platform-tools #add to bashrc
#android avd