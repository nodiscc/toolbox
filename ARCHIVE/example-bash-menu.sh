#!/bin/bash
#Description: Example interactive menu in bash

# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

###################### Main menu
############################################

_BMenuMain() {
    selection=
    until [ "$selection" = "0" ]; do
         echo ""
         echo "========== MAIN MENU =========="
         echo "1 - Tools Menu"
         echo "2 - User account and permissions menu"
         echo "3 - Backup menu"
         echo "4 - System maintenance and troubleshooting Menu"
         echo "5 - Edit main configuration file"
         echo "6 - Services configuration"
         echo "7 - Power off"
         echo "8 - Reboot"
         echo ""
         echo "0 - Exit program"
         echo ""
         echo -n "Enter Selection: "

         read selection
         echo ""
         case $selection in
             1 ) _BMenuTools;; #OK
             2 ) _BMenuUserAccount;; #OK
             3 ) source ${B_PATH}/scripts/BMenuBackup; _BMenuBackup;; #OK
             4 ) _BMenuTroubleshooting;; #OK
             5 ) _BEditMainConfig;;
             6 ) source ${B_PATH}/scripts/BMenuServices; _BMenuServices;;
             7 ) source ${B_PATH}/scripts/BMenuTroubleshooting; _BPoweroff;;
             8 ) source ${B_PATH}/scripts/BMenuTroubleshooting; _BReboot;;
             0 ) return 0;;
             * ) echo "Please enter a valid number"
         esac
    done
}

_BMenuMain