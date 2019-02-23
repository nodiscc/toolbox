#!/bin/bash
#Description: convert a man page to pdf
#Usage: man2pdf MANPAGE
command="$1"
pdfviewer="xdg-open"
openwithviewer="yes"
man -t "$command" | ps2pdf - "$command.pdf" > "/tmp/$command.pdf"
if [[ "$openwithviewer" == "yes" ]]; then "$pdfviewer" "/tmp/$command.pdf"; fi
