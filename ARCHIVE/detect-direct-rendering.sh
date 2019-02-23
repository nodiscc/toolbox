#!/bin/bash
#Description: Detects if OpenGL direct rendering is available and displays an information dialog.
DRITEST=`glxinfo | grep -i "direct rendering: yes"`
if [ "$DRITEST" = "direct rendering: Yes" ]
	then zenity --info --title="Pilotes de carte graphique" --text="L\'accélération vidéo fonctionne! Votre carte graphique est détectée comme étant:

\<b\>`lspci | grep -i vga`\</b\>"
	sed -i 's/Hidden=false/Hidden=true/' $HOME/.config/autostart/dridetect.desktop
	else zenity --info --title="Pilotes de carte graphique" --text="Il semble que l\'accélération video ne soit pas disponible sur ce système. Certains effets video ne seront pas disponibles et les performances seront réduites. Vous devriez peut-être installer les \<b\>pilotes\</b\> pour votre carte graphique. Plus d\'informations sur \<a href=\"https://code.google.com/p/rxtx-linux/wiki/PaquetsRecommandes\"\>https://code.google.com/p/rxtx-linux/wiki/PaquetsRecommandes\</a\>. Votre carte graphique est détectée comme étant:

\<b\>`lspci | grep -i vga`\</b\>"
fi
