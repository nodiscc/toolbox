#!/bin/bash
# Description: install ardour audio workstation (dev version)
set -o errexit

sudo apt-get install libboost-all-dev  libasound2-dev libglib2.0-dev  glibmm-2.4-dev  libsndfile1-dev  libcurl4-gnutls-dev  liblo-dev  libtag1-dev  vamp-plugin-sdk  librubberband-dev  libfftw3-dev  libaubio-dev  libxml2-dev  libcwiid-dev  jack  libjack-jackd2-dev  jackd  qjackctl  liblrdf0-dev  libsamplerate-dev  lv2-dev  libserd-dev  libsord-dev  libsratom-dev  liblilv-dev  libgtkmm-2.4-dev  libarchive-dev git
sudo apt-get install git
git clone https://github.com/Ardour/ardour
cd ardour/
./waf configure
./waf
sudo checkinstall ./waf install
qjackctl &
ardour6