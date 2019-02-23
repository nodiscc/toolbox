#!/bin/bash
#Description: Change resolution to a non-natively supported one.
#Example: broken edge on screen
#Works on Intel cards.
#License: MIT (http://opensource.org/licenses/MIT)
#Source: https://github.com/nodiscc/scriptz
#Thanks to barti_ddu at http://superuser.com/questions/347437


echo "creating mode line for Xrandr..."
xrandr --newmode "976x600_60.00"   46.50  976 1016 1112 1248  600 603 613 624 -hsync +vsync
echo "adding mode to Xrandr..."
xrandr --addmode LVDS1 976x600_60.00
echo "Switching Xrandr to new mode..."
xrandr --output LVDS1 --mode 976x600_60.00 --set "scaling mode" Center
