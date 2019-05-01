#!/bin/bash
# Description: formats and displays a text file in conky

if [[ -f "$HOME/.config/conky/config" ]]
	then source "$HOME/.config/conky/config"
	else echo -e "TEXTFILE=\"\"" >> ~/.config/conky/config
fi

# shellcheck disable=SC2002
cat "$TEXTFILE" |tr "\n" " "   | cut -f 1 -d '#' | fold -w 60