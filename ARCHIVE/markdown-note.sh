#!/bin/bash
#Description: generate a markdown "note"
# attempt to reproduce https://www.dokuwiki.org/plugin:note in markdown.
# Outputs a markdown table (not supported in core markdown, but some markdown implementations allow it)
# allowing to add a "note" in markdown documentation.
# This is a simple 2 columns table with a symbol in the left pane, correspoding to a note type.
# Currently warning, important, tip and note note types are supported.
# This uses fairly common unicode symbol and should work with many common fonts.
# If you find a common font that does not support one of the characters, please report it.

USAGE="USAGE: `basename $0` [warning|important|tip|note]"

case $1 in
	"")
	echo "$USAGE"
	;;
	"warning")
	echo -e "| 💥 |           |\n|---------|---------|" | xclip -selection c
	;;
	"important")
	echo -e "| ❢ |           |\n|---------|---------|" | xclip -selection c
	;;
	"tip")
	echo -e "| 💡 |           |\n|---------|---------|" | xclip -selection c
	;;
	"note")
	echo -e "| 📖 |           |\n|---------|---------|" | xclip -selection c
	;;
#	*)
#	echo -e "| $1 |           |\n|---------|---------|" | xclip -selection c
#	;;
esac
