#!/bin/bash
#Description: simple dialog presenting randomly generated passwords
#Requires pwgen
zenity --window-icon=info --title="Pwgen" --info --text="$(pwgen -s 19 -n 5)"