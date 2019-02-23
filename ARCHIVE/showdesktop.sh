#!/bin/sh
#Description: toggle Openbox's "Show Desktop" mode on or off

_GetConkyOnTop() {
instances=$(wmctrl -lp | grep Conky)
IDS=$(echo "$instances" | cut -f1 -d" ")
for i in $IDS; do wmctrl -ia $i; done
}

SHOWDESKTOPSTATUS=`wmctrl -m | tail -n 1 | awk '{print $7'}`
if [ "$SHOWDESKTOPSTATUS" = "ON" ]
	then wmctrl -k off
elif [ "$SHOWDESKTOPSTATUS" = "OFF" ]
	then wmctrl -k on; _GetConkyOnTop
fi
