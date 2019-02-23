#!/bin/bash
#Description: use a video as screensaver
#Requires mplayer
## setup MPlayer aruments, remove -nosound if you want the video
## to play sound. If you have to specify the video driver to use
## then add that to the list
MPLAYERARGS="-nosound -nolirc -wid $XSCREENSAVER_WINDOW -nostop-xscreensaver -fs -really-quiet -loop 0"

## path to video
VIDEO=~/.config/videoscreensaver.avi

exec mplayer $MPLAYERARGS "$VIDEO"
