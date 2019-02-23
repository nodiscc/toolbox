#!/bin/bash
#Description: display an Apple-II style terminal with cathodic screen
#Inspired from cathode. You will need xscreensaver and xscreensaver-data-extra
#packages
#Source:
#License: WTFPL

/usr/lib/xscreensaver/apple2 -text -fast -bs -program bash

#have fun!
#optional: -mono renders a monochrome screen
#optional: -use-cmap 1 gives a different feeling
#
#other cool xscreensaver hacks (some in xscreensaver-gl{,-extra}):
#interaggregate
#intermomentary
#glmatrix
#m6502
#metaballs
#/usr/lib/xscreensaver/phosphor -delay 7000 -scale 2 -program bash
#xanalogtv (images directory must be setup in ~/.xscreensaver)
